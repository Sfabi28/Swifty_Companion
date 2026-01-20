import 'package:flutter/material.dart';

class BasicInfoScreen extends StatelessWidget {
  final dynamic user;

  const BasicInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(221, 0, 0, 0),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          user.login,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 20),

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
          child: Stack(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundColor: const Color.fromARGB(255, 238, 238, 238),
                backgroundImage: NetworkImage(user.imageUrl),
              ),

              Positioned(
                bottom: 0,
                right: 5,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: (user.location != null) ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: user.isStaff ? Colors.red : Colors.black87,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.isStaff
                ? "STAFF"
                : user.grade.replaceAll('_', ' ').toUpperCase(),

            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Level ${user.level.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Color.fromARGB(255, 168, 38, 207),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

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
