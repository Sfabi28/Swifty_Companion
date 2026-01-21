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
    int targetCursusId = 21;
    List<dynamic> cursusUsers = json['cursus_users'] ?? [];
    if (cursusUsers.any((c) => c['cursus_id'] == 21)) {
      targetCursusId = 21;
    } else if (cursusUsers.any((c) => c['cursus_id'] == 9)) {
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
    }

    var extractedSkills = <Skill>[];
    if (cursusUsers.isNotEmpty) {
      var tc = cursusUsers.firstWhere(
        (c) => c['cursus_id'] == targetCursusId,
        orElse: () => cursusUsers.first,
      );
      if (tc['skills'] != null) {
        tc['skills'].forEach((v) => extractedSkills.add(Skill.fromJson(v)));
      }
    }
    var campusList = <Campus>[];
    if (json['campus'] != null) {
      json['campus'].forEach((v) => campusList.add(Campus.fromJson(v)));
    }

    var extractedProjects = <Project>[];

    if (json['projects_users'] != null) {
      List<dynamic> rawProjects = json['projects_users'];

      for (var pUser in rawProjects) {
        String pName = pUser['project'] != null
            ? pUser['project']['name'] ?? "Unknown"
            : "Unknown";
        String pSlug = pUser['project'] != null
            ? pUser['project']['slug'] ?? ""
            : "";

        List<int> cIds = [];
        if (pUser['cursus_ids'] != null) {
          pUser['cursus_ids'].forEach((id) {
            if (id is int) cIds.add(id);
          });
        }

        if (targetCursusId == 21 && cIds.contains(9)) continue;
        if (targetCursusId == 9 && !cIds.contains(9)) continue;

        List<dynamic> teams = pUser['teams'] ?? [];

        if (teams.isNotEmpty) {
          for (var team in teams) {
            extractedProjects.add(
              Project(
                name: pName,
                slug: pSlug,
                status: team['status'] ?? "finished",
                validated: team['validated?'],
                finalMark: team['final_mark'],
                cursusIds: cIds,
                teamId: team['id'] ?? 0,
              ),
            );
          }
        } else {
          extractedProjects.add(
            Project(
              name: pName,
              slug: pSlug,
              status: pUser['status'] ?? "unknown",
              validated: pUser['validated?'],
              finalMark: pUser['final_mark'],
              cursusIds: cIds,
              teamId: pUser['id'] ?? 0,
            ),
          );
        }
      }
    }

    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      fullName: json['displayname'] ?? json['usual_full_name'] ?? "Unknown",
      imageUrl: json['image']?['link'] ?? "",
      wallet: json['wallet'] ?? 0,
      correctionPoint: json['correction_point'] ?? 0,
      level: extractedLevel,
      location: json['location'],
      poolMonth: json['pool_month'],
      poolYear: json['pool_year'],
      campus: campusList,
      grade: extractedGrade,
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
  factory Campus.fromJson(Map<String, dynamic> json) =>
      Campus(id: json['id'], name: json['name']);
}

class Skill {
  final int id;
  final String name;
  final double level;
  Skill({required this.id, required this.name, required this.level});
  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'],
    name: json['name'],
    level: (json['level'] as num).toDouble(),
  );
}

class Project {
  final String name;
  final String status;
  final bool? validated;
  final int? finalMark;
  final String slug;
  final List<int> cursusIds;
  final int teamId;

  Project({
    required this.name,
    required this.status,
    this.validated,
    this.finalMark,
    required this.slug,
    required this.cursusIds,
    required this.teamId
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: "Deprecated",
      status: "Deprecated",
      slug: "",
      cursusIds: [],
      teamId: 0,
    );
  }
}
