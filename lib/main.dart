import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final authService = AuthService();

  print("--- CONNECTING ---");
  await authService.getToken();
  print("--- END CONNECTION ---");

  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(child: Text("Test Token in corso...")),
    ),
  ));
}