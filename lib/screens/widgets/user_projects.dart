import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../templates/project_template.dart';

class UserProjects extends StatelessWidget {
  final User user;

  const UserProjects({super.key, required this.user});

  Map<String, List<Project>> _groupProjects(List<Project> projects) {
    Map<String, List<Project>> grouped = {};

    for (var p in projects) {
      if (!grouped.containsKey(p.slug)) {
        grouped[p.slug] = [];
      }
      grouped[p.slug]!.add(p);
    }

    grouped.forEach((key, list) {
      list.sort((a, b) {
        bool valA = a.validated ?? false;
        bool valB = b.validated ?? false;
        if (valA && !valB) return -1;
        if (!valA && valB) return 1;

        int markA = a.finalMark ?? 0;
        int markB = b.finalMark ?? 0;
        if (markA != markB) {
          return markB.compareTo(markA);
        }

        if (a.status == 'finished' && b.status != 'finished') return -1;
        if (a.status != 'finished' && b.status == 'finished') return 1;

        return 0;
      });
    });

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (user.projects.isEmpty) return const SizedBox.shrink();

    final groupedProjects = _groupProjects(user.projects);

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
              "PROJECTS",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Colors.black87,
              ),
            ),
          ),

          ...groupedProjects.entries.map((entry) {
            final List<Project> history = entry.value;
            final Project bestProject = history.first;

            if (history.length == 1) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: _cardDecoration(),
                  padding: const EdgeInsets.all(2),
                  child: ProjectCard(project: bestProject),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: _cardDecoration(),
                clipBehavior: Clip.hardEdge,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.grey,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.only(left: 5, right: 10),
                    childrenPadding: const EdgeInsets.only(
                      bottom: 10,
                      left: 10,
                      right: 10,
                    ),

                    title: ProjectCard(project: bestProject),

                    children: history.skip(1).map((oldProject) {
                      return ProjectCard(project: oldProject, isHeader: false);
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),

      border: Border.all(color: Colors.grey),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
