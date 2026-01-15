import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'search_screen.dart'; // Importa la schermata successiva

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Istanziamo il servizio di Auth
  final AuthService _authService = AuthService();
  
  // Variabile per sapere se stiamo caricando (per mostrare la rotellina)
  bool _isLoading = false;

  void _loginWith42() async {
    // 1. Attiva la rotellina di caricamento
    setState(() {
      _isLoading = true;
    });

    // 2. Lancia la procedura di Autenticazione (apre il browser)
    final bool success = await _authService.authenticate();

    // Se l'utente chiude l'app mentre carica, ci fermiamo per evitare errori
    if (!mounted) return;

    // 3. Spegni la rotellina
    setState(() {
      _isLoading = false;
    });

    // 4. Se il login è andato a buon fine, cambia pagina
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    } else {
      // Altrimenti mostra errore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login fallito! Riprova."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"), 
            fit: BoxFit.cover,
          ),
        ),
        
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/42_Logo.png",
                  width: 120, // Larghezza del logo (regolala se troppo grande/piccola)
                  height: 120, 
                  color: Colors.white,
                ),
                
                const SizedBox(height: 20),

                // TITOLO
                Text(
                  "Swifty Companion",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // BOTTONE LOGIN (O ROTELLINA)
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white) // Se carica, mostra rotella
                    : ElevatedButton.icon(
                        onPressed: _loginWith42,
                        icon: const Icon(Icons.login),
                        label: const Text(
                          "LOGIN WITH 42",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black, // Colore testo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}