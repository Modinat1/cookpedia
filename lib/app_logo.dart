import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  /// Diameter of the circular logo image.
  final double size;

  const AppLogo({super.key, this.size = 100});

  // Network URL for the logo image
  // free icon-hosting URL so it can be fetched live.
  static const String logoUrl =
      'https://cdn-icons-png.flaticon.com/512/1830/1830839.png';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Rounded corners around the network image
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.network(
        logoUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        // Shown while the image is downloading from the network
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            color: const Color(0xFFF05A5A).withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF05A5A)),
              ),
            ),
          );
        },
        // Fallback if the network image fails to load (e.g. no internet)
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFF05A5A),
              borderRadius: BorderRadius.circular(size * 0.22),
            ),
            child: Icon(
              Icons.restaurant,
              size: size * 0.5,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
