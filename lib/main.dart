import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart'; // Serve per SystemChrome
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Blocco rotazione (già che ci siamo lo rimettiamo)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Errore .env: $e");
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/background.png"), context);

    return MaterialApp(
      title: 'Swifty Companion',
      debugShowCheckedModeBanner: false,
      
      // --- MODIFICA FONDAMENTALE QUI ---
      theme: ThemeData(
        useMaterial3: true,
        // 1. Diciamo che l'app è SCURA. Questo elimina il bianco di default.
        brightness: Brightness.dark, 
        
        // 2. Forziamo la trasparenza ovunque
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        
        // 3. Configuriamo lo schema colori per evitare sorprese
        colorScheme: const ColorScheme.dark(
          background: Colors.transparent, // Vecchio standard
          surface: Colors.transparent,    // Standard Material 3
          primary: Colors.blue,           // Il tuo colore primario
        ),
      ),
      // --------------------------------

      builder: (context, child) {
        return Stack(
          children: [
            // A. Sfondo Nero di sicurezza
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black, // Se flasha, flasha nero su nero = invisibile
            ),

            // B. Immagine
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // C. L'App
            child!, 
          ],
        );
      },

      home: const LoginScreen(),
    );
  }
}