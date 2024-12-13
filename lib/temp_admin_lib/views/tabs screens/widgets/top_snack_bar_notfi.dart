import 'package:flutter/material.dart';
import 'package:shiplan_service/temp_admin_lib/views/tabs%20screens/widgets/linear_notfi.dart';

void showTopSnackBar(
    BuildContext context, String message, IconData icon, Color color, Duration duration) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0, // Distance from the top of the screen
      left: 10.0,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: NotificationWithProgressBar(
          message: message,
          icon: icon,
          color: color,
          duration: duration,
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  // Remove the overlay after the duration completes
  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}
