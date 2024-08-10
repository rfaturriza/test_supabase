import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  final String errorCode;
  final String errorDescription;

  const ErrorPage({
    super.key,
    required this.error,
    required this.errorCode,
    required this.errorDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Error Code: $errorCode', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Error Description: $errorDescription', style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}