import 'dart:convert';
import 'package:flutter/foundation.dart'; // Serve per debugPrint
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService;

  ApiService(this._authService);

  Future<User?> getMe() async {
    // usiamo lo stesso controllo token di getUser
    if (_authService.isTokenExpired) {
      final success = await _authService.refreshToken();
      if (!success) return null;
    }

    final token = _authService.accessToken;
    if (token == null) return null;

    // l'endpoint magico che dice "chi sono io?"
    final url = Uri.parse('https://api.intra.42.fr/v2/me');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        if (response.statusCode == 401) _authService.logout();
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<User?> getUser(String login) async {
  
    if (_authService.isTokenExpired) {
      debugPrint("⚠️ Il token è scaduto (o sta per scadere). Rinnovo in corso...");
      
      final success = await _authService.refreshToken(); // se il token attuale è scaduto allora cerchiamo di rinnovarlo
      
      if (!success) { //anche il token di rinnovo è scaduto allora serve un login manuale per refresharli
        debugPrint("❌ Impossibile rinnovare il token. Serve login manuale.");
        return null;
      }
    }

    // 2. Ora siamo sicuri che il token è valido (o vecchio ma ancora buono, o appena rinnovato)
    final token = _authService.accessToken;
    
    if (token == null) { // check in caso fallisse qualcosa
      debugPrint("Errore: Nessun token in memoria.");
      return null;
    }

    final url = Uri.parse('https://api.intra.42.fr/v2/users/$login'); //cerco l'utente di cui voglio reperire le info

    try {
      final response = await http.get( //aspetto la risposta dell'API passandogli il token
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // SUCCESSO, decodifico il JSON e poi lo parso utilizzando la funzione in User
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {

        debugPrint("Errore API ${response.statusCode}: ${response.body}");
        
        // se per qualche motivo il token non è piu valido allora dobbiamo fare il logout (o chiamo tenattivo di refresh?)
        if (response.statusCode == 401) {
           _authService.logout();
        }
        
        return null;
      }
    } catch (e) {
      debugPrint("Eccezione connessione: $e");
      return null;
    }
  }
}