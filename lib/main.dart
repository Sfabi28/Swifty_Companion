import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ File .env trovato e caricato correttamente.");
  } catch (e) {
    debugPrint("❌ File .env NON trovato. Errore: $e");
  }

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