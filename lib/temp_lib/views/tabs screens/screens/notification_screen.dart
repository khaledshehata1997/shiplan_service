import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_lib/generated/l10n.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> get() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData) {
          return Center(child: Text(S.of(context).NoNotificationsFound));
        } else if (snapshot.hasError) {
          return Center(
            child: Text(S.of(context).NoNotificationsFound),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
