import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_store/models/food_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/mock_data.dart';
import '../widgets/category_chip.dart';
import '../widgets/food_card.dart';
import 'details_screen.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMain = isDark ? AppColors.textMainDark : AppColors.textMain;
    
    // Filter items based on category
    final filteredItems = selectedCategory == 'All' 
        ? mockFoodItems 
        : mockFoodItems.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: _buildHeader(context, textMain),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSearchBar(context),
              ),
              const SizedBox(height: 25),
              const ShuffleBanner(),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCategorySection(textMain),
              ),
              const SizedBox(height: 30),
              _buildFeaturedSection(filteredItems, textMain),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPopularSection(mockFoodItems, textMain),
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

  Widget _buildHeader(BuildContext context, Color textMainColor) {
    final authService = AuthService();
    final user = authService.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
    final safeName = userName.isEmpty ? 'User' : userName;
    final cappedName = safeName[0].toUpperCase() + safeName.substring(1).toLowerCase();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

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
                color: textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hungry? Order Now! 🍔',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textMainColor,
              ),
            ),
          ],
        ),
        // Consumer<ThemeProvider>(
        //   builder: (context, themeProvider, child) {
        //     return Container(
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).colorScheme.surface,
        //         borderRadius: BorderRadius.circular(15),
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black.withOpacity(0.05),
        //             blurRadius: 10,
        //             offset: const Offset(0, 5),
        //           ),
        //         ],
        //       ),
        //       child: IconButton(
        //         icon: Icon(
        //           themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        //           color: AppColors.primary,
        //           size: 22,
        //         ),
        //         onPressed: () => themeProvider.toggleTheme(),
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 55,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
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
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
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

  Widget _buildSectionHeader(String title, VoidCallback onTap, Color textMainColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textMainColor,
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

  Widget _buildCategorySection(Color textMainColor) {
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
        }, textMainColor),
        const SizedBox(height: 16),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
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

  Widget _buildFeaturedSection(List<FoodItem> items, Color textMainColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSectionHeader('Recommended', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeeAllScreen(title: 'Recommended', items: mockFoodItems),
              ),
            );
          }, textMainColor),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length > 5 ? 5 : items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FoodCard(
                  food: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(food: items[index]),
                      ),
                    );
                  },
                  onAdd: () {
                    context.read<CartProvider>().addItem(items[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${items[index].name} added to cart!'),
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

  Widget _buildPopularSection(List<FoodItem> items, Color textMainColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular Nearby', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeeAllScreen(title: 'Popular Nearby', items: mockFoodItems),
            ),
          );
        }, textMainColor),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length > 3 ? 3 : items.length,
          itemBuilder: (context, index) {
            final food = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(food: food),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          food.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textMainColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              food.category,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${food.price.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 30),
                        onPressed: () {
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
