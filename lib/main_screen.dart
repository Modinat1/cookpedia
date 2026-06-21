import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'placeholder_tab.dart';
import '../profile_screen.dart';

/// MainScreen is a [StatefulWidget] because it must track which
/// bottom-nav tab is currently selected (_selectedIndex) and rebuild
/// the body when the user taps a different tab.
class MainScreen extends StatefulWidget {
  // Data passed in from Login (email only) or Register (name + email)
  // via the constructor — this is how data flows between screens.
  final String name;
  final String email;

  const MainScreen({super.key, required this.name, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Tracks which tab is active. 0 = Home is the default.
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens shown for each tab, built once per build() call so
    // they always reflect the latest widget.name / widget.email.
    final List<Widget> tabs = [
      // ── Tab 0: Home — shows welcome message with the Login email ───────
      HomeTab(email: widget.email),

      // ── Tab 1: Cart — simple placeholder ────────────────────────────────
      const PlaceholderTab(
        icon: Icons.shopping_cart_outlined,
        label: 'Your Cart',
      ),

      // ── Tab 2: Profile — existing ProfileScreen, now fed real data ──────
      ProfileScreen(name: widget.name, email: widget.email),

      // ── Tab 3: Notifications — simple placeholder ───────────────────────
      const PlaceholderTab(
        icon: Icons.notifications_none_rounded,
        label: 'Notifications',
      ),

      // ── Tab 4: Settings — simple placeholder ────────────────────────────
      const PlaceholderTab(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // IndexedStack keeps all tabs alive in memory and just shows/hides
      // the selected one — this preserves scroll position/state per tab.
      body: IndexedStack(index: _selectedIndex, children: tabs),

      // ── Bottom Navigation Bar ──────────────────────────────────────────
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Builds the bottom navigation bar matching the provided UI design:
  /// rounded top corners, white background, teal active color,
  /// grey inactive icons, with labels under each icon.
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          // setState updates _selectedIndex and rebuilds body with the
          // newly selected tab's screen.
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // keeps all 5 labels visible
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2BA9C7), // Teal active color
          unselectedItemColor: Colors.grey.shade500,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              // Cart icon used here instead of the "Videos" icon
              // shown in the reference image, per the written spec.
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              activeIcon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
