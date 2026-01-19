class User {
  final int id;
  final String login;
  final String email;
  final String fullName;
  final String imageUrl;
  final int wallet;
  final int correctionPoint;
  final double level;

  final String? location;
  final String? poolMonth;
  final String? poolYear;
  final List<Campus> campus;

  final String grade;
  final String? kind;

  User({
    required this.id,
    required this.login,
    required this.email,
    required this.fullName,
    required this.imageUrl,
    required this.wallet,
    required this.correctionPoint,
    required this.level,
    this.location,
    this.poolMonth,
    this.poolYear,
    required this.campus,
    required this.grade,
    this.kind,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    double extractedLevel = 0.0;
    String extractedGrade = "Novice";

    if (json['cursus_users'] != null &&
        (json['cursus_users'] as List).isNotEmpty) {
      var cursus = (json['cursus_users'] as List).firstWhere(
        (c) => c['cursus_id'] == 21,
        orElse: () => (json['cursus_users'] as List).first,
      );

      extractedLevel = (cursus['level'] as num).toDouble();

      extractedGrade = cursus['grade'] ?? "poolr";
    }

    var campusList = <Campus>[];
    if (json['campus'] != null) {
      json['campus'].forEach((v) {
        campusList.add(Campus.fromJson(v));
      });
    }

    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      fullName: json['displayname'] ?? json['usual_full_name'] ?? "Unknown",
      imageUrl: json['image']['link'] ?? "",
      wallet: json['wallet'] ?? 0,
      correctionPoint: json['correction_point'] ?? 0,
      level: extractedLevel,
      location: json['location'],
      poolMonth: json['pool_month'],
      poolYear: json['pool_year'],
      campus: campusList,

      grade: extractedGrade.isNotEmpty
          ? extractedGrade
          : (json['kind'] ?? "Student"),
        
      kind: json['kind']
    );
  }
}

class Campus {
  final int id;
  final String name;

  Campus({required this.id, required this.name});

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(id: json['id'], name: json['name']);
  }
}
