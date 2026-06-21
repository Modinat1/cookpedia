import 'package:flutter/material.dart';
import '../app_logo.dart';
import 'main_screen.dart';

/// RegisterScreen is a [StatefulWidget] because it manages multiple
/// text field controllers and validation state.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // One controller per input field on the Register form.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  // Holds an error message to display, or null if everything is valid.
  String? _errorMessage;

  /// Validates the form, then navigates to MainScreen passing
  /// both name and email forward via the constructor.
  void _handleRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // setState updates _errorMessage, which causes the UI to rebuild
    // and show/hide the inline error text below the fields.
    setState(() {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please fill in all required fields';
      } else if (password != confirmPassword) {
        _errorMessage = 'Passwords do not match';
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage == null) {
      // Navigate to MainScreen, passing BOTH name and email this time
      // (Register collects both, unlike Login which only collects email).
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(name: name, email: email),
        ),
      );
    }
  }

  /// Frees all controllers when this screen is disposed.
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // Allows scrolling so the keyboard never causes an overflow
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar: back arrow + "Register" title ────────────────
                _buildTopBar(),

                const SizedBox(height: 24),

                // ── Centered logo + app name ───────────────────────────────
                Center(
                  child: Column(
                    children: [
                      const AppLogo(size: 80),
                      const SizedBox(height: 10),
                      const Text(
                        'Cookpedia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── NAME ────────────────────────────────────────────────────
                _buildLabel('NAME'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Enter your full name',
                ),

                const SizedBox(height: 18),

                // ── PHONE OR EMAIL ──────────────────────────────────────────
                _buildLabel('PHONE OR EMAIL'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your phone or email',
                ),

                const SizedBox(height: 18),

                // ── PASSWORD ────────────────────────────────────────────────
                _buildLabel('PASSWORD'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Create a password',
                  obscureText: true,
                ),

                const SizedBox(height: 18),

                // ── CONFIRM PASSWORD ────────────────────────────────────────
                _buildLabel('CONFIRM PASSWORD'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Re-enter your password',
                  obscureText: true,
                ),

                const SizedBox(height: 18),

                // ── BIRTHDATE ────────────────────────────────────────────────
                _buildLabel('BIRTHDATE'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _birthdateController,
                  hintText: 'Enter your birth date',
                ),

                // ── Validation error (only shown when present) ────────────
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],

                const SizedBox(height: 32),

                // ── Register button ────────────────────────────────────────
                _buildRegisterButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top bar with back arrow and centered "Register" title.
  Widget _buildTopBar() {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
          const Text(
            'Register',
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

  /// Small uppercase label shown above each field.
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

  /// Pill-shaped outlined text field, matching the Register design.
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

  /// Full-width teal "Register" pill button.
  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2BA9C7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Register',
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
