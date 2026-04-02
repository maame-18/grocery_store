import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../models/topping.dart';
import '../providers/cart_provider.dart';
import '../utils/app_colors.dart';

class DetailsScreen extends StatefulWidget {
  final FoodItem food;

  const DetailsScreen({super.key, required this.food});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int quantity = 1;
  final List<Topping> selectedToppings = [];
  final TextEditingController _noteController = TextEditingController();

  final List<Topping> _allToppings = [
    // Proteins
    const Topping(id: 'p1', name: 'Extra Beef Patty', price: 4.50, category: 'Proteins', type: SelectionType.checkbox),
    const Topping(id: 'p2', name: 'Grilled Chicken', price: 3.50, category: 'Proteins', type: SelectionType.checkbox),
    const Topping(id: 'p3', name: 'Crispy Bacon', price: 2.00, category: 'Proteins', type: SelectionType.checkbox),
    
    // Sauces (Radio example - only one sauce)
    const Topping(id: 's1', name: 'BBQ Sauce', price: 0.50, category: 'Sauces', type: SelectionType.radio),
    const Topping(id: 's2', name: 'Honey Mustard', price: 0.50, category: 'Sauces', type: SelectionType.radio),
    const Topping(id: 's3', name: 'Spicy Mayo', price: 0.50, category: 'Sauces', type: SelectionType.radio),
    
    // Extras
    const Topping(id: 'e1', name: 'Cheddar Cheese', price: 1.50, category: 'Extras', type: SelectionType.checkbox),
    const Topping(id: 'e2', name: 'Caramelized Onions', price: 1.00, category: 'Extras', type: SelectionType.checkbox),
    const Topping(id: 'e3', name: 'Jalapeños', price: 0.75, category: 'Extras', type: SelectionType.checkbox),
    const Topping(id: 'e4', name: 'Avocado', price: 2.50, category: 'Extras', type: SelectionType.checkbox),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  double get _currentTotalPrice {
    double toppingsPrice = selectedToppings.fold(0, (sum, item) => sum + item.price);
    return (widget.food.price + toppingsPrice) * quantity;
  }

  void _toggleTopping(Topping topping) {
    setState(() {
      if (topping.type == SelectionType.radio) {
        // Remove other radio toppings from the same category
        selectedToppings.removeWhere((t) => t.category == topping.category);
        selectedToppings.add(topping);
      } else {
        if (selectedToppings.contains(topping)) {
          selectedToppings.remove(topping);
        } else {
          selectedToppings.add(topping);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 20),
                  _buildRatingSection(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('About this food'),
                  const SizedBox(height: 12),
                  Text(
                    widget.food.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 35),
                  _buildCustomizationSection(),
                  const SizedBox(height: 35),
                  _buildNotesSection(),
                  const SizedBox(height: 35),
                  _buildQuantitySelector(),
                  const SizedBox(height: 120), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomButton(context),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.textMainDark 
            : AppColors.textMain,
      ),
    );
  }

  Widget _buildCustomizationSection() {
    final categories = _allToppings.map((t) => t.category).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Customise your dish'),
        const SizedBox(height: 8),
        Text(
          'Select additional toppings or extras',
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        ...categories.map((cat) => _buildToppingCategory(cat)),
      ],
    );
  }

  Widget _buildToppingCategory(String category) {
    final categoryToppings = _allToppings.where((t) => t.category == category).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.textSecondary.withOpacity(0.6),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...categoryToppings.map((topping) => _buildToppingItem(topping)),
        ],
      ),
    );
  }

  Widget _buildToppingItem(Topping topping) {
    final isSelected = selectedToppings.contains(topping);

    return InkWell(
      onTap: () => _toggleTopping(topping),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.08) 
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon/Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: topping.type == SelectionType.radio ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: topping.type == SelectionType.checkbox ? BorderRadius.circular(6) : null,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected 
                  ? Icon(
                      topping.type == SelectionType.radio ? Icons.circle : Icons.check, 
                      size: 14, 
                      color: Colors.white
                    ) 
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topping.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.textMainDark 
                          : AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),
            if (topping.price > 0)
              Text(
                '+\$${topping.price.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Special Instructions'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Add a note (e.g. no onions, extra spicy...)',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 350,
      elevation: 0,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: widget.food.id,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: widget.food.imageUrl,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent, Colors.black.withOpacity(0.4)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.food.name,
                style: GoogleFonts.inter(
                  fontSize: 28, 
                  fontWeight: FontWeight.w900, 
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.textMainDark 
                      : AppColors.textMain
                ),
              ),
              Text(
                widget.food.category,
                style: GoogleFonts.inter(
                  fontSize: 14, 
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.textSecondaryDark 
                      : AppColors.textSecondary
                ),
              ),
            ],
          ),
        ),
        Text(
          '\$${widget.food.price.toStringAsFixed(2)}',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        _buildInfoChip(Icons.star, Colors.amber, widget.food.rating.toString()),
        const SizedBox(width: 16),
        _buildInfoChip(Icons.access_time_filled, Colors.blue, widget.food.deliveryTime),
        const SizedBox(width: 16),
        _buildInfoChip(Icons.local_fire_department, Colors.orange, '450 Cal'),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, Color iconColor, String label) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14, 
            fontWeight: FontWeight.w600, 
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textSecondaryDark 
                : AppColors.textSecondary
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuantityBtn(Icons.remove, () {
              if (quantity > 1) setState(() => quantity--);
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                quantity.toString().padLeft(2, '0'),
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ),
            _buildQuantityBtn(Icons.add, () {
              setState(() => quantity++);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedToppings.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedToppings.length} Extras selected',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    Text(
                      '+\$${selectedToppings.fold(0.0, (double sum, t) => sum + t.price).toStringAsFixed(2)}',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 65),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                elevation: 0,
              ),
              onPressed: () {
                final cartProvider = context.read<CartProvider>();
                for (int i = 0; i < quantity; i++) {
                  cartProvider.addItem(
                    widget.food, 
                    toppings: selectedToppings,
                    note: _noteController.text,
                  );
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$quantity ${widget.food.name} added to cart!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'Add to Cart • \$${_currentTotalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
