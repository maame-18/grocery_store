import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/session_manager.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final userEmail = user?.email ?? 'user@example.com';
    final userName = userEmail.split('@')[0];
    final safeName = userName.isEmpty ? 'User' : userName;
    final displayUserName = safeName[0].toUpperCase() + safeName.substring(1).toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildProfileHeader(displayUserName, userEmail),
            const SizedBox(height: 30),
            _buildStatsSection(),
            const SizedBox(height: 40),
            _buildMenuSection(context),
            const SizedBox(height: 40),
            _buildLogoutButton(context, authService),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain,
          ),
        ),
        Text(
          email,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Orders', '12'),
            _buildDivider(),
            _buildStatItem('Points', '450'),
            _buildDivider(),
            _buildStatItem('Coupons', '3'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMenuTitle('Account Settings'),
          const SizedBox(height: 15),
          _buildMenuItem(Icons.person_outline_rounded, 'Personal Details'),
          _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders'),
          _buildMenuItem(Icons.payment_rounded, 'Payment Methods'),
          _buildMenuItem(Icons.location_on_outlined, 'Delivery Address'),
          const SizedBox(height: 30),
          _buildMenuTitle('Preferences'),
          const SizedBox(height: 15),
          _buildMenuItem(Icons.notifications_none_rounded, 'Notifications', trailing: _buildToggle(true)),
          _buildMenuItem(Icons.dark_mode_outlined, 'Dark Mode', trailing: _buildToggle(false)),
          const SizedBox(height: 30),
          _buildMenuTitle('Support'),
          const SizedBox(height: 15),
          _buildMenuItem(Icons.help_outline_rounded, 'Help Center'),
          _buildMenuItem(Icons.info_outline_rounded, 'About Us'),
        ],
      ),
    );
  }

  Widget _buildMenuTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textMain,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.textMain, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textMain,
              ),
            ),
          ),
          trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildToggle(bool value) {
    return Container(
      width: 35,
      height: 20,
      decoration: BoxDecoration(
        color: value ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: value ? 17 : 2,
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthService authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () async {
          await authService.signOut();
          await SessionManager.clearSession();
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              (route) => false,
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Log Out',
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
