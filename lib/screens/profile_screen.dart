import 'dart:io';
import 'package:flutter/material.dart';
import 'package:swifty_companion/screens/widgets/user_skills.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../screens/login_screen.dart';

import '../screens/widgets/basic_info_screen.dart';
import '../screens/widgets/user_data.dart';
import '../screens/widgets/user_economy.dart';
import '../screens/widgets/user_projects.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService(AuthService());

  void _logout() {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    debugPrint("Ricerca avviata per: $query");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
            ),
            SizedBox(width: 15),
            Text(
              "Searching for user...", 
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
          ],
        ),
        backgroundColor: Colors.white,
        duration: Duration(days: 1),
      ),
    );

    try {
      final searchedUser = await _apiService.getUser(query);

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      setState(() {
        _isSearching = false;
        _searchController.clear();
      });

      if (searchedUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: searchedUser),
          ),
        );
      }
    } on SocketException {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 10),
              Text("No Internet Connection", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      String errorMessage = "User not found";

      if (e.toString().contains("User not found")) {
        errorMessage = "User not found";
      } else {
        errorMessage = "Error: ${e.toString()}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                tooltip: 'Find User',
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.black87, fontSize: 18),
                cursorColor: const Color.fromARGB(180, 18, 30, 46),
                onSubmitted: (_) => _performSearch(),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  hintText: "login name",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
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
                widget.user.login,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _performSearch,
            ),
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
              color: const Color.fromARGB(200, 255, 255, 255),
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
                    color: const Color.fromARGB(255, 214, 214, 214),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      BasicInfoScreen(user: widget.user),
                      const SizedBox(height: 15),
                      const Divider(
                        color: Color.fromARGB(150, 0, 0, 0),
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      const SizedBox(height: 15),
                      UserEconomy(user: widget.user),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                UserData(user: widget.user),
                const SizedBox(height: 20),
                UserSkills(user: widget.user),
                const SizedBox(height: 20),
                UserProjects(user: widget.user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
