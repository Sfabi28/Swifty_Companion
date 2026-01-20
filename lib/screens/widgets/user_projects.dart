import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../templates/project_template.dart';

class UserProjects extends StatefulWidget {
  final User user;

  const UserProjects({super.key, required this.user});

  @override
  State<UserProjects> createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjects> {
  late Map<String, List<Project>> _groupedProjects;

  @override
  void initState() {
    super.initState();
    _groupedProjects = _groupProjects(widget.user.projects);
  }

  Map<String, List<Project>> _groupProjects(List<Project> projects) {
    Map<String, List<Project>> grouped = {};
    for (var p in projects) {
      if (!grouped.containsKey(p.slug)) grouped[p.slug] = [];
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
        return markB.compareTo(markA);
      });
    });
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 214, 214, 214),
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

          if (widget.user.projects.isEmpty)
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text("Nessun progetto trovato per questo utente."),
            )
          else
            // Usiamo _groupedProjects calcolato in initState
            ..._groupedProjects.entries.map((entry) {
              final List<Project> history = entry.value;
              final Project bestProject = history.first;
              final int hiddenCount = history.length - 1;

              if (hiddenCount <= 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ProjectCard(project: bestProject),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black12, 
                        blurRadius: 4, 
                        offset: Offset(0, 2)
                      )
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      dense: true,
                      trailing: const SizedBox.shrink(),
                      
                      title: ProjectCard(
                        project: bestProject, 
                        hasShadow: false, 
                        count: hiddenCount, 
                      ),

                      children: history.skip(1).map((oldProject) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ProjectCard(project: oldProject, isHistory: true),
                        );
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
}