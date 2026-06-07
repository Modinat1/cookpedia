import 'package:flutter/material.dart';
import 'dart:async';
import 'profile_screen.dart';

/// SplashScreen is a [StatefulWidget] because it manages animations
/// and a timer that triggers navigation after 3 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// _SplashScreenState uses TWO AnimationControllers:
///   1. _entryController  — one-shot fade + scale-in for the logo on load
///   2. _pulseController  — repeating scale pulse on the logo
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Entry animation (fade + scale in)
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _entryScaleAnimation;

  // ── Pulse animation (repeating breathe effect on the logo)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ── Pulse ring animation (expanding ring that fades out)
  late Animation<double> _ringScaleAnimation;
  late Animation<double> _ringOpacityAnimation;

  /// initState() sets up both animation controllers and starts the nav timer.
  @override
  void initState() {
    super.initState();

    // 1. Entry animation: 900ms, plays once
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeIn));

    _entryScaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    // 2. Pulse animation: 1.4s per cycle, repeats forever
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Logo gently scales between 1.0 and 1.08 (subtle breathe)
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Ring expands from 1.0x to 1.6x the logo size
    _ringScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.6,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Ring fades from 0.5 opacity to 0 as it expands
    _ringOpacityAnimation = Tween<double>(
      begin: 0.45,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    // Play entry animation, then start pulsing once it finishes
    _entryController.forward().then((_) {
      // repeat(reverse: true) goes 1.0→1.08→1.0→1.08 … endlessly
      _pulseController.repeat(reverse: true);
    });

    // Start the 3-second navigation timer
    _startNavigationTimer();
  }

  /// Waits 3 seconds then uses setState + Navigator.pushReplacement
  /// to swap the splash screen for the profile screen.
  void _startNavigationTimer() {
    Timer(const Duration(seconds: 3), () {
      // setState signals a rebuild — here we use it to mark navigation intent.
      setState(() {
        // _isNavigating = true  (could be used to freeze the pulse, etc.)
      });

      // pushReplacement removes SplashScreen from the back stack entirely.
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  /// dispose() clean up BOTH controllers to prevent memory leaks.
  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Animated logo and title
            // AnimatedBuilder listens to BOTH controllers and rebuilds when
            // either changes value.
            AnimatedBuilder(
              animation: Listenable.merge([_entryController, _pulseController]),
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation, // entry fade-in
                  child: ScaleTransition(
                    scale: _entryScaleAnimation, // entry scale-in
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pulsating logo wrapper
                        // Stack layers: expanding ring  →  pulsing logo box
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer pulse ring — expands and fades out
                              Opacity(
                                opacity: _ringOpacityAnimation.value,
                                child: Transform.scale(
                                  scale: _ringScaleAnimation.value,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(
                                        0xFFF05A5A,
                                      ).withOpacity(0.25),
                                    ),
                                  ),
                                ),
                              ),

                              // Middle ring (slightly smaller, offset timing)
                              Opacity(
                                opacity: (_ringOpacityAnimation.value * 0.6)
                                    .clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: (_ringScaleAnimation.value * 0.75)
                                      .clamp(1.0, 1.6),
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(
                                        0xFFF05A5A,
                                      ).withOpacity(0.18),
                                    ),
                                  ),
                                ),
                              ),

                              // Logo box
                              Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF05A5A),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF05A5A)
                                            .withOpacity(
                                              0.35 * _pulseAnimation.value,
                                            ),
                                        blurRadius: 24,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.restaurant,
                                        size: 52,
                                        color: Colors.white,
                                      ),
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF4CAF50),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.eco,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // App name
                        const Text(
                          'Cookpedia',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const Spacer(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
