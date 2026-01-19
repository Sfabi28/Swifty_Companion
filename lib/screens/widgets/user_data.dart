import 'package:flutter/material.dart';
import '../widgets/info_template.dart';

class UserData extends StatelessWidget {
  final dynamic user;

  const UserData({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String locationDisplay = user.location ?? "Unavailable";
    final bool isAvailable = user.location != null;

    String campusName = "Unknown";

    if (user.campus != null && user.campus.isNotEmpty) {
      campusName = user.campus[0].name;
    }

    return Column(
      children: [
        InfoCard(
          label: "Email",
          value: user.email,
          icon: Icons.email_outlined,
          color: Colors.blue,
        ),

        InfoCard(
          label: "Location",
          value: locationDisplay,
          icon: isAvailable ? Icons.computer : Icons.desktop_access_disabled,
          color: isAvailable ? Colors.green : Colors.grey,
        ),

        InfoCard(
          label: "Campus",
          value: campusName,
          icon: Icons.location_city,
          color: Colors.purple,
        ),

        InfoCard(
          label: "piscine Year",
          value: "${user.poolMonth} - ${user.poolYear}",
          icon: Icons.pool,
          color: Colors.orange,
        ),
      ],
    );
  }
}
