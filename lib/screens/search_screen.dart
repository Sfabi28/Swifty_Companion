import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // --- LOGIC VARIABLES ---
  final TextEditingController _controller = TextEditingController();

  // Nota: Passiamo AuthService() che ora deve essere un Singleton per mantenere il token
  final ApiService _apiService = ApiService(AuthService());

  // <--- 3. Variabile per la rotellina di caricamento
  bool _isLoading = false;

  // Function called when the user presses the Search button
  void _searchUser() async {
    // 1. Hide the keyboard
    FocusScope.of(context).unfocus();

    final login = _controller.text.trim();

    // 2. Validation: Check if input is empty
    if (login.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid login!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // B. Chiediamo i dati (User?)
    final user = await _apiService.getUser(login);

    // Se l'utente chiude l'app mentre carichiamo, ci fermiamo
    if (!mounted) return;

    // C. Spegniamo la rotellina
    setState(() {
      _isLoading = false;
    });

    // D. Controlliamo il risultato
    if (user != null) {
      // SUCCESSO: Abbiamo l'oggetto User pieno di dati!
      debugPrint("Utente trovato: ${user.fullName} - Livello: ${user.level}");

      // QUI CAMBIEREMO PAGINA (Prossimo step)
      /*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: user),
        ),
      );
      */
    } else {
      // ERRORE: Utente non trovato o token scaduto
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not found or API error."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- UI ZONE ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Makes the background image extend behind the AppBar
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "Swifty Companion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent, // Transparent to show the image
        elevation: 0, // Removes the shadow
        foregroundColor: Colors.white, // White text/icons
        centerTitle: true,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover, // Fills the screen completely
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Spacer to push elements down a bit
                const SizedBox(height: 80),

                // Main Title
                Text(
                  "Search 42 Profile",

                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4.0,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Input Field
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black87, fontSize: 20),
                  cursorColor: Color.fromARGB(221, 0, 153, 255),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 20),
                    hintText: "e.g. sfabi",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color.fromARGB(221, 0, 153, 255),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Solid white background
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
                ),

                const SizedBox(height: 20),

                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(
                            221,
                            0,
                            153,
                            255,
                          ), // Blu come il bottone
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _searchUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: const Color.fromARGB(
                            221,
                            0,
                            153,
                            255,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "SEARCH",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
