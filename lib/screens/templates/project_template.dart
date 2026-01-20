import 'package:flutter/material.dart';
import '../../models/user.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool isHistory;
  final bool hasShadow;
  final int? count; // Il numero di tentativi extra (+X)

  const ProjectCard({
    super.key,
    required this.project,
    this.isHistory = false,
    this.hasShadow = true,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    // Logica Colori
    Color statusColor = Colors.grey;
    int? mark = project.finalMark;
    bool isValidated = project.validated ?? false;
    String status = project.status;

    if (isValidated) {
      statusColor = Colors.green;
    } else if (mark != null && mark >= 80) {
      statusColor = Colors.green;
    } else if (mark != null && mark < 80) {
      statusColor = Colors.red;
    } else if (status == "in_progress" || status == "creating_group" || status == "searching_a_group") {
      statusColor = Colors.orange;
    } else if (status == "waiting_for_correction") {
      statusColor = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: isHistory ? 10 : 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: hasShadow && !isHistory
            ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
            : [],
        border: isHistory ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LATO SINISTRO: Solo il Nome
          Expanded(
            child: Text(
              project.name,
              style: TextStyle(
                fontWeight: isHistory ? FontWeight.normal : FontWeight.bold,
                fontSize: isHistory ? 14 : 16,
                color: isHistory ? Colors.grey.shade700 : Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // LATO DESTRO: [Badge] + [Voto]
          // Usiamo una Row con minAxisSize per tenerli compatti a destra
          Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // 1. IL BADGE (Se esiste, lo mostriamo PRIMA del voto)
              if (count != null && count! > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    "+$count",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Spazio tra badge e voto
              ],

              // 2. IL VOTO (Sempre allineato a destra)
              if (mark != null)
                SizedBox(
                  // Un piccolo width fisso opzionale per allineare i numeri (es. 30px)
                  // Se preferisci che sia fluido, rimuovi il Container e lascia solo Text
                  child: Text(
                    "$mark",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isHistory ? 14 : 16,
                      color: statusColor,
                    ),
                  ),
                )
              else
                Text(
                  status.replaceAll('_', ' '),
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ],
      ),
    );
  }
}