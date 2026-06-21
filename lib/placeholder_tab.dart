import 'package:flutter/material.dart';

/// PlaceholderTab is a reusable [StatelessWidget] for simple tabs
/// that just need to show an icon and a label (Cart, Notifications, Settings).
/// Reusing one widget for all three avoids duplicating near-identical code.
class PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String label;

  const PlaceholderTab({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Large icon representing the tab
          Icon(icon, size: 64, color: const Color(0xFF2BA9C7)),
          const SizedBox(height: 16),

          // Tab label text
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}
