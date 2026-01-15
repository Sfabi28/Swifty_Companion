import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SearchScreen extends StatefulWidget { //classe di configurazione iniziale che deve essere separata dalla classe di stato (cambia nel tempo)
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  // --- ZONA VARIABILI (LOGICA) ---
  final TextEditingController _controller = TextEditingController(); //configuro la cattura del testo scritto dall'utente
  final AuthService _authService = AuthService(); //creo un'istanza dela mia classe AuthService

  // --- ZONA GRAFICA (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cerca")),
      body: Column(
        children: [
        ],
      ),
    );
  }
}