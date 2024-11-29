import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/constants/colors.dart';

class NotificationTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final String subtitle;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 61,
              width: 61,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: defaultColor,
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey.shade600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ListTile(
//       leading:
//   CircleAvatar(
//         child: Icon(icon),
//       ),
//       title: Text(title),
//       subtitle:
//   Text(subtitle),
//     );
