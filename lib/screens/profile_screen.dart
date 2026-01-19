import 'package:flutter/material.dart';
import 'package:swifty_companion/screens/widgets/user_skills.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../screens/login_screen.dart';

import '../screens/widgets/basic_info_screen.dart';
import '../screens/widgets/user_data.dart';
import '../screens/widgets/user_economy.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Variabile per gestire se stiamo cercando o no
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  // Istanzio il service (meglio se lo passi o usi un provider, ma va bene così per ora)
  final ApiService _apiService = ApiService(AuthService());

  // Funzione Logout
  void _logout() {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // Funzione che esegue la ricerca vera e propria
  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // Chiude la tastiera
    FocusScope.of(context).unfocus();

    debugPrint("Ricerca avviata per: $query");

    // Chiamo API per ricerca utente
    // NOTA: Assicurati che _apiService gestisca gli errori (try/catch) internamente
    // o avvolgi questo in un try/catch per evitare crash se l'API fallisce.
    final searchedUser = await _apiService.getUser(query);

    if (!mounted) return;

    // Resetta la barra di ricerca dopo l'invio
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });

    if (searchedUser != null) {
      // Naviga al nuovo profilo se esiste
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: searchedUser),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "User not found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. FONDAMENTALE: Sfondo trasparente per vedere l'immagine del main.dart
      backgroundColor: Colors.transparent,

      // Evita che lo sfondo si "schiacci" quando apri la tastiera
      resizeToAvoidBottomInset: false,

      // Fa sì che l'AppBar sia sopra il corpo (utile per trasparenze)
      extendBodyBehindAppBar: true,

      // Imposto l'appbar (la parte in alto)
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Trasparente
        elevation: 0, // Niente ombra
        foregroundColor: Colors.white, // Icone e testo bianchi
        // Logica del tasto Sinistro (Back o Lente)
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearching = false; // Annulla ricerca
                    _searchController.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                tooltip: 'Find User',
                onPressed: () {
                  setState(() {
                    _isSearching = true; // Attiva modalità ricerca
                  });
                },
              ),

        // Logica del Titolo (Barra di ricerca o Nome Utente)
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true, // Apre subito la tastiera
                style: const TextStyle(color: Colors.black87, fontSize: 18),
                cursorColor: const Color.fromARGB(180, 18, 30, 46),
                onSubmitted: (_) =>
                    _performSearch(), // Cerca quando premi invio
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  hintText: "login name", // Meglio specificare cosa cercare
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ), // Più rotondo è più bello
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(180, 18, 30, 46),
                      width: 2,
                    ),
                  ),
                ),
              )
            : Text(
                widget.user.login, // Titolo normale
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

        centerTitle: true,

        actions: [
          // Se sto cercando, aggiungo la lente qui a destra per confermare (opzionale)
          if (_isSearching)
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ), // Icona Check è più intuitiva per "conferma"
              onPressed: _performSearch,
            ),

          // Il tasto logout c'è sempre
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
              top: 50,
            ),

            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(20, 0, 0, 0),
                    borderRadius: BorderRadius.circular( 20 ),
                  ),
                  child: Column(
                    children: [
                      BasicInfoScreen(
                        user: widget.user,
                      ),

                      const SizedBox(height: 15),

                      const Divider(
                        color: Color.fromARGB(150, 0, 0, 0),
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                      ),

                      const SizedBox(height: 15),

                      UserEconomy(user: widget.user), // Wallet e Punti
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                UserData(user: widget.user), //
                const SizedBox(height: 20),
                UserSkills(user: widget.user), //
                //const SizedBox(height: 800), // Spazio extra
              ],
            ),
          ),
        ),
      ),
    );
  }
}
