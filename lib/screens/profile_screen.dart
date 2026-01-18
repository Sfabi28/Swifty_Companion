import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // variabile per gestire se stiamo cercando o no
  bool _isSearching = false;
  
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService(AuthService());

  // funzione Logout
  void _logout() {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // funzione che esegue la ricerca vera e propria
  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // chiude la tastiera
    FocusScope.of(context).unfocus();

    debugPrint("Ricerca avviata per: $query");
    
    //chiamo API per ricerca utente
    final searchedUser = await _apiService.getUser(query);
    
    if (!mounted) return;
    
    // resetta la barra di ricerca dopo l'invio
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });

    if (searchedUser != null) {
      // naviga al nuovo profilo se esiste
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

      resizeToAvoidBottomInset: false,

      extendBodyBehindAppBar: true,
 
      //imposto l'appbar (la parte in alto)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false; // annulla ricerca
                    _searchController.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Find User',
                onPressed: () {
                  setState(() {
                    _isSearching = true; // attiva modalità ricerca
                  });
                },
              ),

        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true, // apre subito la tastiera
                style: const TextStyle(color: Colors.black87, fontSize: 18),
                cursorColor: const Color.fromARGB(221, 0, 153, 255),
                onSubmitted: (_) => _performSearch(),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  hintText: "name",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(221, 0, 153, 255),
                      width: 2,
                    ),
                  ),
                ),
              )
            : Text(widget.user.login), // titolo normale (nome dell'utente se non sono in ricerca)

        centerTitle: true,

        actions: [
          // se sto cercando, aggiungo la lente qui a destra per confermare
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _performSearch, // Lancia la ricerca
            ),
            
          // il tasto logout c'è sempre
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.fullName,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Level ${widget.user.level.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}