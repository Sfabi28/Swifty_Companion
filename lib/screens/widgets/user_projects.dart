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

  final Map<String, bool> _expandedStates = {};

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
        return b.teamId.compareTo(a.teamId);
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
              child: Text("No project found for this user"),
            )
          else
            ..._groupedProjects.entries.map((entry) {
              final String projectSlug = entry.key;
              final List<Project> history = entry.value;
              final Project bestProject = history.first;
              final int hiddenCount = history.length - 1;

              bool isExpanded = _expandedStates[projectSlug] ?? false;

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
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      visualDensity: VisualDensity.compact,
                      listTileTheme: const ListTileThemeData(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        horizontalTitleGap: 0,
                      ),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      dense: true,

                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _expandedStates[projectSlug] = expanded;
                        });
                      },

                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.grey,
                        ),
                      ),

                      title: ProjectCard(
                        project: bestProject,
                        hasShadow: false,
                        count: hiddenCount,
                      ),

                      children: history.asMap().entries.skip(1).map((entry) {
                        int index = entry.key;
                        Project oldProject = entry.value;
                        int chronologicalNumber = history.length - index - 1;

                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ProjectCard(
                            project: oldProject,
                            isHistory: true,
                            index: chronologicalNumber,
                          ),
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
