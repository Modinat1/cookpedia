import 'package:flutter/material.dart';

/// ProfileScreen is a [StatelessWidget] because it only displays
/// content passed in from outside — it has no state that changes over time.
/// StatelessWidgets are simpler and more performant for read-only UI.
class ProfileScreen extends StatelessWidget {
  // Name and email are passed in via the constructor from MainScreen,
  // which in turn received them from either the Login or Register screen.
  final String name;
  final String email;

  const ProfileScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          // SingleChildScrollView prevents overflow on smaller screens
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Navigation Bar ─────────────────────────────────
              _buildTopBar(),

              // Vertical spacing
              const SizedBox(height: 16),

              // ── Profile Info Section ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildProfileInfo(),
              ),

              const SizedBox(height: 12),

              // ── Bio Section ────────────────────────────────────────
              // Now displays the name and email passed from
              // Login/Register instead of hardcoded values.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildBio(),
              ),

              const SizedBox(height: 20),

              // ── Tab Bar (Recipe / Videos / Tag) ────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTabBar(),
              ),

              const SizedBox(height: 16),

              // ── Recipe Cards ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildRecipeCard(
                  title: 'Traditional spare ribs\nbaked',
                  author: 'By Chef John',
                  duration: '20 min',
                  rating: '4.0',
                  // Using a network food image as placeholder
                  imageUrl:
                      'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildRecipeCard(
                  title: 'spice roasted chicken\nwith flavored rice',
                  author: 'By Mark Kelvin',
                  duration: '20 min',
                  rating: '4.0',
                  imageUrl:
                      'https://images.unsplash.com/photo-1598103442097-8b74394b95c3?w=400',
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widget Builder Methods ─────────────────────────────────────────────────

  /// Builds the top app bar with title and menu icon.
  /// Uses a [Row] to place title and icon on opposite ends.
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Screen title
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),

          // Three-dot menu icon
          const Icon(Icons.more_horiz, color: Color(0xFF1A1A2E), size: 28),
        ],
      ),
    );
  }

  /// Builds the profile header: avatar + stats (Recipe, Followers, Following).
  /// Uses [Row] and [Column] to arrange items side by side.
  Widget _buildProfileInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Profile Avatar ───────────────────────────────────────────
        // CircleAvatar displays the profile photo in a circle
        CircleAvatar(
          radius: 42,
          backgroundColor: const Color(0xFFE0E0E0), // Fallback grey
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1583394293214-0b7e50e3b8ee?w=200',
          ),
          // Fallback icon if image fails to load
          onBackgroundImageError: (_, __) {},
          child: null,
        ),

        // Spacing between avatar and stats
        const SizedBox(width: 20),

        // ── Stats Row ────────────────────────────────────────────────
        // Expanded makes the stats fill the remaining horizontal space
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Recipe count stat
              _buildStatColumn('Recipe', '4'),

              // Vertical divider between stats
              Container(height: 30, width: 1, color: Colors.grey.shade300),

              // Followers count stat
              _buildStatColumn('Followers', '2.5M'),

              // Vertical divider
              Container(height: 30, width: 1, color: Colors.grey.shade300),

              // Following count stat
              _buildStatColumn('Following', '259'),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper to build a single stat column (label + value).
  /// [Column] stacks the label on top of the value.
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        // Label (e.g. "Recipe", "Followers")
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 4),

        // Value (e.g. "4", "2.5M")
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  /// Builds the name + bio section below the profile header.
  /// Displays the [name] and [email] passed into ProfileScreen's constructor
  /// — these come from whichever screen the user authenticated through
  /// (Register passes both name + email; Login passes only email).
  Widget _buildBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full name — falls back to a placeholder if empty (e.g. user
        // came from Login, which doesn't collect a name).
        Text(
          name.isNotEmpty ? name : 'Guest Chef',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),

        const SizedBox(height: 2),

        // Job title/role
        Text(
          'Chef',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),

        const SizedBox(height: 8),

        // Email passed in from Login/Register, shown with an icon
        Row(
          children: [
            Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              email.isNotEmpty ? email : 'No email provided',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Bio text with emoji accents
        Text(
          'Passionate about food and life 🍔🍕🌮📚',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 4),

        // "More..." link text
        const Text(
          'More...',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF4CAF82), // Green accent color
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds the tab bar with Recipe (active), Videos, and Tag tabs.
  /// The active tab has a green background; inactive tabs are plain text.
  Widget _buildTabBar() {
    return Row(
      children: [
        // ── Active Tab: Recipe ────────────────────────────────────────
        // Container with green background and rounded corners
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF82), // Green active color
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'Recipe',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // ── Inactive Tab: Videos ──────────────────────────────────────
        const Text(
          'Videos',
          style: TextStyle(
            color: Color(0xFF9E9E9E), // Grey for inactive
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),

        const SizedBox(width: 16),

        // ── Inactive Tab: Tag ─────────────────────────────────────────
        const Text(
          'Tag',
          style: TextStyle(
            color: Color(0xFF4CAF82), // Green tint for "Tag"
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Builds a single recipe card with an image, title, author, rating, and duration.
  ///
  /// [title] - Name of the recipe
  /// [author] - Author's display name
  /// [duration] - Cook time string (e.g. "20 min")
  /// [rating] - Rating value (e.g. "4.0")
  /// [imageUrl] - Network URL for the food photo
  Widget _buildRecipeCard({
    required String title,
    required String author,
    required String duration,
    required String rating,
    required String imageUrl,
  }) {
    return Container(
      height: 180,
      width: double.infinity,
      // ClipRRect clips the child to a rounded rectangle
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Food Image ─────────────────────────────────────────────
          // Image.network loads a photo from the internet
          Image.network(
            imageUrl,
            fit: BoxFit.cover, // Cover fills the container without distortion
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image fails: show a grey placeholder
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.restaurant,
                  size: 48,
                  color: Colors.grey,
                ),
              );
            },
          ),

          // ── Dark Gradient Overlay ──────────────────────────────────
          // DecoratedBox adds a gradient so text is readable over the photo
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),

          // ── Rating Badge (top-right) ───────────────────────────────
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107), // Amber/yellow for rating
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 12, color: Colors.white),
                  const SizedBox(width: 3),
                  Text(
                    rating,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Info Row (title, author, duration, bookmark) ────
          Positioned(
            bottom: 10,
            left: 12,
            right: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Title and author stacked vertically
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Recipe title
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Author name
                      Text(
                        author,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Duration Badge ──────────────────────────────────
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                // ── Bookmark Icon Button ─────────────────────────────
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
