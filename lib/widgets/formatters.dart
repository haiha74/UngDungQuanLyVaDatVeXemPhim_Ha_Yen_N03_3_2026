import 'package:flutter/material.dart';

String formatMoney(int amount) {
  final text = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return '$buffer VND';
}

String formatDateTime(DateTime value) {
  final date = '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  final time = '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  return '$date - $time';
}

Widget errorView(String message, {VoidCallback? onRetry}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 42),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    ),
  );
}
