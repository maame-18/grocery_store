import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/tab_provider.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    
    return Scaffold(
      body: PageTransitionSwitcher(
        index: tabProvider.currentIndex,
        child: _screens[tabProvider.currentIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(tabProvider),
    );
  }

  Widget _buildBottomNavigationBar(TabProvider tabProvider) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25, left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home', tabProvider),
            _buildCartNavItem(1, tabProvider),
            _buildNavItem(2, Icons.favorite_rounded, 'Wishlist', tabProvider),
            _buildNavItem(3, Icons.person_rounded, 'Profile', tabProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildCartNavItem(int index, TabProvider tabProvider) {
    final isSelected = tabProvider.currentIndex == index;
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return GestureDetector(
          onTap: () => tabProvider.setTab(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      size: 24,
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${cart.itemCount}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Cart',
                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, TabProvider tabProvider) {
    final isSelected = tabProvider.currentIndex == index;
    return GestureDetector(
      onTap: () => tabProvider.setTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PageTransitionSwitcher extends StatelessWidget {
  final int index;
  final Widget child;

  const PageTransitionSwitcher({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(index),
        child: child,
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.textSecondary.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Text(
              'This screen is coming soon!',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
