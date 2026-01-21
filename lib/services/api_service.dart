import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  final AuthService _authService;

  ApiService(this._authService);

  Future<List<dynamic>> _fetchAllProjectsRaw(int userId, String token) async {
    debugPrint("user id is: $userId");
    List<dynamic> allProjects = [];
    int pageNumber = 1;
    bool keepFetching = true;

    while (keepFetching) {
      final url = Uri.parse(
        'https://api.intra.42.fr/v2/projects_users?filter[user_id]=$userId&page[size]=100&page[number]=$pageNumber',
      );

      try {
        debugPrint("🔄 Scarico pagina $pageNumber...");
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          List<dynamic> pageData = jsonDecode(response.body);
          if (pageData.isEmpty) {
            keepFetching = false;
          } else {
            allProjects.addAll(pageData);
            if (pageData.length < 30) {
              keepFetching = false;
            } else {
              pageNumber++;
            }
          }
        } else {
          keepFetching = false;
        }
      } on SocketException {
        throw const SocketException("No Internet Connection");
      } catch (e) {
        debugPrint("Errore generico loop: $e");
        keepFetching = false;
      }
    }
    return allProjects;
  }

  Future<User?> getMe() async {
    if (_authService.isTokenExpired) await _authService.refreshToken();
    final token = _authService.accessToken;
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('https://api.intra.42.fr/v2/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return await _buildUserWithHistory(jsonDecode(response.body), token);
      } else {
        if (response.statusCode == 401) _authService.logout();
        return null;
      }
    } on SocketException {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUser(String login) async {
    if (_authService.isTokenExpired) await _authService.refreshToken();
    final token = _authService.accessToken;
    if (token == null) throw Exception("No Token");

    try {
      final response = await http.get(
        Uri.parse('https://api.intra.42.fr/v2/users/$login'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return await _buildUserWithHistory(jsonDecode(response.body), token);
      } else if (response.statusCode == 404) {
        throw Exception("User not found");
      } else {
        throw Exception("API Error");
      }
    } on SocketException {
      throw const SocketException("No Internet Connection");
    } catch (e) {
      rethrow;
    }
  }

  Future<User> _buildUserWithHistory(
    Map<String, dynamic> userData,
    String token,
  ) async {
    final int userId = userData['id'];
    userData['projects_users'] = await _fetchAllProjectsRaw(userId, token);
    return User.fromJson(userData);
  }
}
