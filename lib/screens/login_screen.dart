import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Istanziamo il servizio di Auth
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _loginWith42() async {
    setState(() { _isLoading = true; });

    // 1. Ottieni il token
    final bool authSuccess = await _authService.authenticate();

    if (!authSuccess) {
      if (!mounted) return;
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Failed!"), backgroundColor: Colors.red),
      );
      return;
    }

    // 2. Login riuscito? Scarichiamo subito il MIO profilo
    final apiService = ApiService(_authService);
    final me = await apiService.getMe();

    if (!mounted) return;
    setState(() { _isLoading = false; });

    if (me != null) {
      // 3. Vado direttamente al Profilo!
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfileScreen(user: me)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error while fetching user"), backgroundColor: Colors.red),
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