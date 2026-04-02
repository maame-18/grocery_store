import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/mock_data.dart';
import '../utils/session_manager.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import 'details_screen.dart';
import 'onboarding_screen.dart';
import 'see_all_screen.dart';
import 'categories_screen.dart';
import '../widgets/shuffle_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Burgers', 'Pizza', 'Salads', 'Snacks', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    // Filter items based on category
    final filteredItems = selectedCategory == 'All' 
        ? mockFoodItems 
        : mockFoodItems.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: _buildHeader(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSearchBar(),
              ),
              const SizedBox(height: 25),
              const ShuffleBanner(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCategorySection(),
              ),
              const SizedBox(height: 30),
              _buildFeaturedSection(filteredItems),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPopularSection(mockFoodItems),
              ),
              const SizedBox(height: 120), // Spacing for floating nav bar
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildHeader(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
    final cappedName = userName[0].toUpperCase() + userName.substring(1).toLowerCase();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getGreeting()}, $cappedName!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hungry? Order Now! 🍔',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.primary, size: 22),
            onPressed: () async {
              final AuthService authService = AuthService();
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
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.grey[400], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for meals...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.tune_rounded, color: Colors.white),
        ),
      ],
    );
  }


  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textMain,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'See All',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Categories', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriesScreen(
                categories: categories,
                onSelect: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CategoryChip(
                label: categories[index],
                isSelected: selectedCategory == categories[index],
                onTap: () {
                  setState(() {
                    selectedCategory = categories[index];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedSection(List filteredItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSectionHeader('Recommended for You', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeeAllScreen(
                  title: 'Recommended',
                  items: mockFoodItems,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
          child: filteredItems.isEmpty 
          ? const Center(child: Text('No items found in this category'))
          : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredItems.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20),
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final food = filteredItems[index];
              return Hero(
                tag: food.id,
                child: FoodCard(
                  food: food,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(food: food),
                      ),
                    );
                  },
                  onAdd: () {
                    context.read<CartProvider>().addItem(food);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${food.name} added to cart!'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSection(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular Nearby', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeeAllScreen(
                title: 'Popular Nearby',
                items: mockFoodItems,
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final food = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(food: food),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: food.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  food.rating.toString(),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppColors.textMain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                food.deliveryTime,
                                style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.local_shipping_rounded, size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                'Free',
                                style: GoogleFonts.inter(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${food.price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded, color: AppColors.textMain, size: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
