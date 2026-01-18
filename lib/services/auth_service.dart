import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  final String _baseUrl = 'https://api.intra.42.fr';
  String? _accessToken; 
  String? _refreshToken;
  DateTime? _expiryDate;

  // Getter: permette di leggere il token da fuori senza poterlo modificare
  String? get accessToken => _accessToken;

  Future<bool> tryAutoLogin() async {
    // leggiamo i dati salvati nel telefono
    final storedAccessToken = await _storage.read(key: 'access_token');
    final storedRefreshToken = await _storage.read(key: 'refresh_token');
    final storedExpiry = await _storage.read(key: 'expiry_date');

    if (storedAccessToken == null || storedRefreshToken == null || storedExpiry == null) {
      return false; // non c'è nulla salvato
    }

    // ripristiniamo le variabili in memoria
    _accessToken = storedAccessToken;
    _refreshToken = storedRefreshToken;
    _expiryDate = DateTime.parse(storedExpiry);

    debugPrint("✅ Auto-Login: Token recuperati dalla memoria.");
    
    // se è scaduto, proviamo subito a rinfrescarlo
    if (isTokenExpired) {
      debugPrint("⚠️ Token salvato scaduto. Tento refresh...");
      return await refreshToken();
    }

    return true;
  }

  // lancia il browser e prende il Codice
  Future<bool> authenticate() async {
    // creo l'url per passare all'intra che gestirà lui la richiesta di login (per sicurezza)
    final url = Uri.https('api.intra.42.fr', '/oauth/authorize', {
      'client_id': dotenv.env['UID'],
      'redirect_uri': 'swifty://callback', 
      'response_type': 'code', // Chiediamo un CODICE, non subito il token
      'scope': 'public', 
    });

    try {
      // chiamiamo l'url appena creato ed aspettiamo finche l'url stesso non redirecta sull'app
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'swifty', // aspettiamo che il browser chiami swifty://...
      );

      // Estraiamo il parametro 'code' dall'URL di callback ricevuto.
      final code = Uri.parse(result).queryParameters['code'];
      
      if (code == null) {
        debugPrint('Errore: Nessun codice ricevuto');
        return false;
      }

      // con il codice ricevuto scambiamolo con un token
      return await _exchangeCodeForToken(code);

    } catch (e) {
      debugPrint('Errore durante il login: $e');
      return false;
    }
  }

  // funzione helper che estrae e salva la data di scadenza del token
  Future<bool> _saveData(Map<String, dynamic> data) async {
    try {
      _accessToken = data['access_token'];
      
      if (data['refresh_token'] != null) {
        _refreshToken = data['refresh_token'];
      }

      //calcoliamo la data esatta di scadenza
      int seconds = data['expires_in'];
      // togliamo 60 secondi per sicurezza (rinnoviamo 1 minuto prima che scada davvero)
      _expiryDate = DateTime.now().add(Duration(seconds: seconds - 60));
      
      //salviamo nella memoria del telefono i token
      await _storage.write(key: 'access_token', value: _accessToken);
      if (_refreshToken != null) {
        await _storage.write(key: 'refresh_token', value: _refreshToken);
      }
      if (_expiryDate != null) {
        await _storage.write(key: 'expiry_date', value: _expiryDate!.toIso8601String());
      }

      debugPrint("✅ Dati salvati. Scadenza: $_expiryDate");
      return true;
    } catch (e) {
      debugPrint("Errore nel salvataggio dati token: $e");
      return false;
    }
  }

  // scambiamo il codice ricevuto dalla callback dell'intra con un token
  Future<bool> _exchangeCodeForToken(String code) async {
    final url = Uri.parse('$_baseUrl/oauth/token');

    final response = await http.post(
      url,
      body: {
        'grant_type': 'authorization_code', 
        'client_id': dotenv.env['UID'],
        'client_secret': dotenv.env['SECRET'],
        'code': code, // utilizziamo il codice che ci ha reso l'intra
        'redirect_uri': 'swifty://callback',
      },
    );

    if (response.statusCode == 200) {
          final data = jsonDecode(response.body); // se riceviamo il token (JSON) allora dcodifichiamolo
          // Usiamo la funzione helper per salvare i dati e calcolare la scadenza.
          return _saveData(data); 
    } else {
      debugPrint("Errore scambio token: ${response.body}");
      return false;
    }
  }

  // funzione per rinnovare il token quando scade
  Future<bool> refreshToken() async {
    // se non abbiamo il refresh token (es. mai fatto login), falliamo subito
    if (_refreshToken == null) {
      debugPrint("Nessun refresh token disponibile.");
      return false;
    }

    final url = Uri.parse('$_baseUrl/oauth/token');

    debugPrint("🔄 Tentativo di rinnovo token...");

    try {
      final response = await http.post(
        url,
        body: {
          'grant_type': 'refresh_token', // adesso cerchiamo il refresh_token
          'refresh_token': _refreshToken, // usiamo la chiave di riserva
          'client_id': dotenv.env['UID'],
          'client_secret': dotenv.env['SECRET'],
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // salviamo i nuovi token
        return _saveData(data);
      } else {
        debugPrint("❌ Rinnovo fallito: ${response.body}");
        // se anche il refresh token è scaduto allora è necessario fare il logout
        logout();
        return false;
      }
    } catch (e) {
      debugPrint("Errore di connessione durante il refresh: $e");
      return false;
    }
  }

  // helper utile per l'ApiService: dice se è ora di rinnovare
  bool get isTokenExpired {
    if (_expiryDate == null) return true; // Se non c'è data, è scaduto
    return DateTime.now().isAfter(_expiryDate!);
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _expiryDate = null;

    await _storage.deleteAll();
    debugPrint("Logout effettuato: Tutti i token rimossi.");
  }
}