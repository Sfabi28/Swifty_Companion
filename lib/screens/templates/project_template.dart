import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isHeader;

  const ProjectCard({super.key, required this.project, this.isHeader = true});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (project.validated == true) {
      statusColor = Colors.green;
    } else if (project.validated == false) {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.grey;
    }

    String markText = project.finalMark != null
        ? "${project.finalMark}"
        : project.status.replaceAll('_', ' ').toUpperCase();

    if (!isHeader) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Icon(
              project.validated == true ? Icons.check_circle : Icons.cancel,
              color: statusColor,
              size: 16,
            ),
            const SizedBox(width: 10),

            Text(
              project.status.replaceAll('_', ' '),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),

            Text(
              markText,
              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              project.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              markText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
