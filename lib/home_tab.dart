import 'package:flutter/material.dart';

/// using the email passed in from the Login screen.
class HomeTab extends StatelessWidget {
  // Email passed down from MainScreen, which got it from LoginScreen.
  final String email;

  const HomeTab({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome icon
            const Icon(Icons.home_rounded, size: 64, color: Color(0xFF2BA9C7)),
            const SizedBox(height: 16),

            // Welcome heading
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),

            // Shows the email passed from Login, or a fallback message
            Text(
              email.isNotEmpty ? email : 'No email available',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
