import 'package:flutter/material.dart';
import '../app_logo.dart';
import 'register_screen.dart';
import './main_screen.dart';

/// the text in its input fields and show validation errors.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers read the current text typed into each field.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Holds a validation error message, or null if there's no error.
  // Changing this triggers setState to show/hide the error text.
  String? _errorMessage;

  /// Validates that both fields are filled, then navigates to MainScreen,
  /// passing the email along via the constructor.
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // setState updates _errorMessage and rebuilds the UI to show/hide it.
    setState(() {
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please fill in both fields';
      } else {
        _errorMessage = null;
      }
    });

    // Only navigate if validation passed (no error message set).
    if (_errorMessage == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Pass the email forward to MainScreen by its constructor.
          // Name is left empty since Login only collects email/phone
          builder: (context) => MainScreen(name: '', email: email),
        ),
      );
    }
  }

  /// Navigates to the RegisterScreen when "Register" is tapped.
  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  /// dispose() frees the controllers when this screen is removed.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Prevents overflow if the keyboard pushes content up
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar: back arrow + "Login" title ───────────────────
                _buildTopBar(),

                const SizedBox(height: 60),

                // ── Centered app logo + name ──────────────────────────────
                Center(
                  child: Column(
                    children: [
                      const AppLogo(size: 90),
                      const SizedBox(height: 12),
                      const Text(
                        'Cookpedia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ── Phone or Email field ──────────────────────────────────
                _buildLabel('PHONE OR EMAIL'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your phone or email',
                ),

                const SizedBox(height: 20),

                // ── Password field ────────────────────────────────────────
                _buildLabel('PASSWORD'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: true,
                ),

                // ── Validation error (only shown when present) ───────────
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],

                const SizedBox(height: 20),

                // ── "don't have an account? Register" row ─────────────────
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "don't have an account? ",
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _goToRegister,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFF2BA9C7), // Teal link color
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),

                // ── Login button ──────────────────────────────────────────
                _buildLoginButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the top bar with a back arrow and centered "Login" title,
  /// matching the design's layout using a [Stack].
  Widget _buildTopBar() {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back arrow aligned to the left
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          // Centered screen title
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Small uppercase label above each input field (e.g. "PHONE OR EMAIL").
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Builds a pill-shaped outlined text field matching the design.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        // Pill-shaped border (fully rounded corners)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF2BA9C7)),
        ),
      ),
    );
  }

  /// Builds the full-width teal "Login" pill button at the bottom.
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2BA9C7), // Teal matching design
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
