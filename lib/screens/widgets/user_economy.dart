import 'package:flutter/material.dart';

class UserEconomy extends StatelessWidget {
  final dynamic user;

  const UserEconomy({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(
                Icons.wallet,
                color: Color.fromARGB(255, 255, 179, 0),
                size: 28,
              ),
              const SizedBox(height: 5),
              Text(
                "${user.wallet} ₳",
                style: const TextStyle(
                  color: Color.fromARGB(255, 204, 142, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Wallet",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.blueAccent,
                size: 28,
              ),
              const SizedBox(height: 5),
              Text(
                "${user.correctionPoint}",
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Ev.P",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
