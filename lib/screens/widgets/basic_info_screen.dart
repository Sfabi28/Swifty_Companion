import 'package:flutter/material.dart';

class BasicInfoScreen extends StatelessWidget {

  final dynamic user;

  const BasicInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. NOME
        Text(
          user.fullName, 
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(221, 0, 0, 0),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 2. LOGIN
        Text(
          user.login,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 20),

        // 3. IMMAGINE PROFILO
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(128, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 80,
            backgroundColor: const Color.fromARGB(255, 238, 238, 238),
            backgroundImage: NetworkImage(user.imageUrl),
          ),
        ),

        const SizedBox(height: 20),

        // 4. LIVELLO (Testo)
        Text(
          "Level ${user.level.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Color.fromARGB(255, 168, 38, 207),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        // 5. BARRA LIVELLO
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: user.level - user.level.floor(),
                  backgroundColor: const Color.fromARGB(255, 224, 224, 224),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 168, 38, 207),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}