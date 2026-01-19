import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../screens/login_screen.dart';

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
        const SnackBar(content: Text("User not found"), backgroundColor: Colors.red),
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
                onSubmitted: (_) => _performSearch(), // Cerca quando premi invio
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  hintText: "login name", // Meglio specificare cosa cercare
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)), // Più rotondo è più bello
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
              icon: const Icon(Icons.check, color: Colors.white), // Icona Check è più intuitiva per "conferma"
              onPressed: _performSearch,
            ),
            
          // Il tasto logout c'è sempre
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),

      // 2. BODY PULITO: Niente Container con immagine!
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar (se vuoi aggiungerlo in futuro)
              // CircleAvatar(backgroundImage: NetworkImage(widget.user.imageUrl), radius: 50),
              
              const SizedBox(height: 20),
              
              Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // Aggiungo un'ombra per leggere meglio il testo sullo sfondo
                  shadows: [
                     Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                  ],
                ),
              ),
              
              const SizedBox(height: 10), // Spazio ridotto
              
              Text(
                "Level ${widget.user.level.toStringAsFixed(2)}", // Formatta a 2 decimali
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, // Colore oro per il livello
                  shadows: [
                     Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}