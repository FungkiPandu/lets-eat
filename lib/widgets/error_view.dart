import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetryPressed;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Image.asset("assets/sorry.png"),
          ),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
          if (onRetryPressed != null) const SizedBox(height: 12),
          if (onRetryPressed != null)
            ElevatedButton(
              onPressed: onRetryPressed,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  Text("Try again"),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
