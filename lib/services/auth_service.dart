import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final String _baseUrl = 'https://api.intra.42.fr';

  String? _accessToken;

  Future<String?> getToken() async {
    final url = Uri.parse('$_baseUrl/oauth/token');

    final uidFromDefine = const String.fromEnvironment('UID');
    final secretFromDefine = const String.fromEnvironment('SECRET');
    final clientId = uidFromDefine.isNotEmpty ? uidFromDefine : (dotenv.env['UID'] ?? '');
    final clientSecret = secretFromDefine.isNotEmpty ? secretFromDefine : (dotenv.env['SECRET'] ?? '');

    if (clientId.isEmpty || clientSecret.isEmpty) {
      if (kDebugMode) {
        debugPrint('Missing UID or SECRET for OAuth2. Set them in .env or pass via --dart-define.');
      }
      return null;
    }

    final response = await http.post(
      url,
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _accessToken = data['access_token'];

      if (kDebugMode) {
        debugPrint('Access token acquired (length: ${_accessToken?.length ?? 0})');
      }

      return _accessToken;
    } else {
      if (kDebugMode) {
        debugPrint('Error in token request: ${response.statusCode}');
      }
      return null;
    }
  }
}