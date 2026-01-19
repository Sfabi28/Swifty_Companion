import 'package:flutter/material.dart';
import '../templates/skill_template.dart';

class UserSkills extends StatelessWidget {
  final dynamic user;

  const UserSkills({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.skills == null || user.skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 15),
            child: Text(
              "SKILLS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.black87,
              ),
            ),
          ),

          ...user.skills.map<Widget>((skill) {
            return SkillCard(skillName: skill.name, level: skill.level);
          }).toList(),
        ],
      ),
    );
  }
}
