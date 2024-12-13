import 'package:flutter/material.dart';

class NotificationWithProgressBar extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;

  const NotificationWithProgressBar({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<NotificationWithProgressBar> createState() =>
      _NotificationWithProgressBarState();
}

class _NotificationWithProgressBarState
    extends State<NotificationWithProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              border: Border(left: BorderSide(color: widget.color, width: 4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: widget.color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(widget.message)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(widget.color),
                    );
                  },
                ),
              ],
            ),
          )
        : const SizedBox.shrink(); // Return an empty widget when not visible
  }
}
