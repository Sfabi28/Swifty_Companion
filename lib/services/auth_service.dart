import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String _baseUrl = 'https://api.intra.42.fr';

  String? _accessToken;

  Future<String?> getToken() async {
    final url = Uri.parse('$_baseUrl/oauth/token');

    final response = await http.post(
      url,
      body: {
        'grant_type': 'client_credentials',
        'client_id': dotenv.env['UID'],
        'client_secret': dotenv.env['SECRET'],
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _accessToken = data['access_token'];

      print("TOKEN RECEIVED: $_accessToken");
      return _accessToken;
    } else {
      print("Error in token request: ${response.statusCode}");
      print(response.body);
      return null;
    }
  }
}