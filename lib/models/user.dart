// import 'package:flutter/material.dart';

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
  final bool isStaff;

  final List<Skill> skills;
  final List<Project> projects;

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
    required this.isStaff,
    required this.skills,
    required this.projects,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    double extractedLevel = 0.0;
    String extractedGrade = "Novice";
    var extractedSkills = <Skill>[];

    int targetCursusId = 21;
    List<dynamic> cursusUsers = json['cursus_users'] ?? [];

    bool hasCursus21 = cursusUsers.any((c) => c['cursus_id'] == 21);
    bool hasPiscine9 = cursusUsers.any((c) => c['cursus_id'] == 9);

    if (hasCursus21) {
      targetCursusId = 21;
    } else if (hasPiscine9) {
      targetCursusId = 9;
    } else if (cursusUsers.isNotEmpty) {
      targetCursusId = cursusUsers.first['cursus_id'];
    }

    if (cursusUsers.isNotEmpty) {
      var targetCursus = cursusUsers.firstWhere(
        (c) => c['cursus_id'] == targetCursusId,
        orElse: () => cursusUsers.first,
      );
      extractedLevel = (targetCursus['level'] as num).toDouble();
      extractedGrade = targetCursus['grade'] ?? "Pisciner";

      if (targetCursus['skills'] != null) {
        targetCursus['skills'].forEach((v) {
          extractedSkills.add(Skill.fromJson(v));
        });
      }
    }

    var campusList = <Campus>[];
    if (json['campus'] != null) {
      json['campus'].forEach((v) {
        campusList.add(Campus.fromJson(v));
      });
    }

    var extractedProjects = <Project>[];

    if (json['projects_users'] != null) {
      List<dynamic> rawProjects = json['projects_users'];

      //debugPrint("DEBUG: Progetti grezzi ricevuti: ${rawProjects.length}");

      for (var v in rawProjects) {
        Project p = Project.fromJson(v);

        if (targetCursusId == 21) {
          if (!p.cursusIds.contains(9)) {
            extractedProjects.add(p);
          }
        } else if (targetCursusId == 9) {
          if (p.cursusIds.contains(9)) {
            extractedProjects.add(p);
          }
        } else {
          extractedProjects.add(p);
        }
      }

     // debugPrint("DEBUG: Progetti dopo filtro: ${extractedProjects.length}");
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
      kind: json['kind'],
      isStaff: json['staff?'] ?? false,
      skills: extractedSkills,
      projects: extractedProjects,
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

class Skill {
  final int id;
  final String name;
  final double level;
  Skill({required this.id, required this.name, required this.level});
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      level: (json['level'] as num).toDouble(),
    );
  }
}

class Project {
  final String name;
  final String status;
  final bool? validated;
  final int? finalMark;
  final String slug;
  final List<int> cursusIds;

  Project({
    required this.name,
    required this.status,
    this.validated,
    this.finalMark,
    required this.slug,
    required this.cursusIds,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    var cIds = <int>[];
    if (json['cursus_ids'] != null) {
      json['cursus_ids'].forEach((v) {
        cIds.add(v as int);
      });
    }

    return Project(
      name: json['project']['name'] ?? "Unknown",
      slug: json['project']['slug'] ?? "",
      status: json['status'],
      validated: json['validated?'],
      finalMark: json['final_mark'],
      cursusIds: cIds,
    );
  }
}
