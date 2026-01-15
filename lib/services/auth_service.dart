import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:flutter/foundation.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final String _baseUrl = 'https://api.intra.42.fr'; //serve per fare il login
  String? _accessToken; 

  // Getter: permette di leggere il token da fuori senza poterlo modificare
  String? get accessToken => _accessToken;

  // FUNZIONE 1: Lancia il browser e prende il Codice
  Future<bool> authenticate() async {
    // 1. Costruiamo l'URL di login
    final url = Uri.https('api.intra.42.fr', '/oauth/authorize', {
      'client_id': dotenv.env['UID'],
      'redirect_uri': 'swifty://callback', 
      'response_type': 'code', // Chiediamo un CODICE, non subito il token
      'scope': 'public', 
    });

    try {
      // 2. Apriamo il browser sicuro
      // L'app si "congela" qui finché l'utente non finisce il login nel browser
      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: 'swifty', // Aspettiamo che il browser chiami swifty://...
      );

      // 3. Estraiamo il codice dalla risposta (es. swifty://callback?code=123...)
      final code = Uri.parse(result).queryParameters['code'];
      
      if (code == null) {
        debugPrint('Errore: Nessun codice ricevuto');
        return false;
      }

      // 4. Passiamo alla Fase 2: scambiare il codice col token
      return await _exchangeCodeForToken(code);

    } catch (e) {
      debugPrint('Errore durante il login: $e');
      return false;
    }
  }

  // FUNZIONE 2: Scambia il Codice temporaneo con il Token definitivo
  Future<bool> _exchangeCodeForToken(String code) async {
    final url = Uri.parse('$_baseUrl/oauth/token');

    final response = await http.post(
      url,
      body: {
        'grant_type': 'authorization_code', 
        'client_id': dotenv.env['UID'],
        'client_secret': dotenv.env['SECRET'],
        'code': code, // Usiamo il codice appena preso
        'redirect_uri': 'swifty://callback',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      debugPrint("LOGIN RIUSCITO! Token: $_accessToken");
      return true;
    } else {
      debugPrint("Errore scambio token: ${response.body}");
      return false;
    }
  }

  void logout() {
    _accessToken = null;
    debugPrint("Logout effettuato: Token rimosso dalla memoria.");
  }
}