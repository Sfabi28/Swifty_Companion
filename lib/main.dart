import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart'; // <--- Importa la LoginScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const SwiftyCompanionApp());
}

class SwiftyCompanionApp extends StatelessWidget {
  const SwiftyCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swifty Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      
      home: const LoginScreen(), 
    );
  }
}