class User {
  final int id;
  final String login;
  final String email;
  final String fullName;
  final String? imageUrl;
  final int wallet;
  final int correctionPoint;
  
  final List<dynamic> cursusUsers;
  final List<dynamic> projectsUsers;

  User({
    required this.id,
    required this.login,
    required this.email,
    required this.fullName,
    this.imageUrl,
    required this.wallet,
    required this.correctionPoint,
    required this.cursusUsers,
    required this.projectsUsers,
  });

  //riempio l'oggetto User dai dati JSON presi dall'API

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      fullName: json['displayname'],
      
      imageUrl: (json['image'] != null && json['image']['link'] != null)
          ? json['image']['link']
          : null,

      wallet: json['wallet'] ?? 0,
      correctionPoint: json['correction_point'] ?? 0,
      
      cursusUsers: json['cursus_users'] ?? [],
      projectsUsers: json['projects_users'] ?? [],
    );
  }

// queste funzioni estraggono il livello e le skills dall'array cursusUsers 
  double get level {
    if (cursusUsers.isEmpty) return 0.0;
    
    for (var c in cursusUsers) {
      if (c['cursus']['id'] == 21) {
        return (c['level'] as num).toDouble();
      }
    }
    return (cursusUsers[0]['level'] as num).toDouble();
  }

  List<dynamic> get skills {
    if (cursusUsers.isEmpty) return [];
    
    for (var c in cursusUsers) {
      if (c['cursus']['id'] == 21) {
        return c['skills'] ?? [];
      }
    }
    return cursusUsers[0]['skills'] ?? [];
  }
}