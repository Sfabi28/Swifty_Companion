import 'dart:io';
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
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final bool hasToken = await _authService.tryAutoLogin();

      if (hasToken) {
        debugPrint("🚀 Token trovato! Recupero dati utente...");

        final apiService = ApiService(_authService);

        final me = await apiService.getMe();

        if (!mounted) return;

        if (me != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileScreen(user: me)),
          );
          return;
        }
      }
    } on SocketException {
      debugPrint("⚠️ Nessuna connessione durante Auto-Login");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Internet Connection.", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint("⚠️ Errore Auto-Login: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loginWith42() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bool authSuccess = await _authService.authenticate();

      if (!authSuccess) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Failed!", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final apiService = ApiService(_authService);
      final me = await apiService.getMe();

      if (!mounted) return;

      if (me != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen(user: me)),
        );
      } else {
        throw Exception("User data is null");
      }
    } on SocketException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
            content: Text("Login Failed!"),
            backgroundColor: Colors.red,
          ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/42_Logo.png",
                width: 120,
                height: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                "Swifty Companion",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      blurRadius: 10,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton.icon(
                      onPressed: _loginWith42,
                      icon: const Icon(Icons.login),
                      label: const Text(
                        "LOGIN WITH 42",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
