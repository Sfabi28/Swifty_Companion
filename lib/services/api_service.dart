import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService;

  ApiService(this._authService);

  Future<User?> getUser(String login) async {
    final token = _authService.accessToken;
    
    if (token == null) return null;

    final url = Uri.parse('https://api.intra.42.fr/v2/users/$login');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}