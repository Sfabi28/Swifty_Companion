import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // aspetto il caricamento del .env (se presente)
  } catch (e) {
    if (kDebugMode) {
      // Non falliamo l'app in produzione per la mancanza del file .env
      debugPrint('.env non trovato o errore nel caricamento: $e');
    }
  }

  runApp(const SwiftyCompanionApp());
}

class SwiftyCompanionApp extends StatelessWidget {
  const SwiftyCompanionApp({super.key}); //costruttore standard di dart

  @override
  Widget build(BuildContext context) { //funzione che viene chiamata ogni volta che ridisegno lo schermo
    return MaterialApp(
      title: 'Swifty Companion',
      theme: ThemeData( //colori globali dell'app
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),

      home: const SearchScreen(), //la prima pagina da vedere quando apro l'app (la mia schermata di search)
    );
  }
}