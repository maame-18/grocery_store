import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/topping.dart';

class CartItem {
  final FoodItem food;
  final List<Topping> toppings;
  final String note;
  int quantity;

  CartItem({
    required this.food,
    this.toppings = const [],
    this.note = '',
    this.quantity = 1,
  });

  double get totalPrice {
    final toppingsTotal = toppings.fold(0.0, (sum, t) => sum + t.price);
    return (food.price + toppingsTotal) * quantity;
  }
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(FoodItem food, {List<Topping>? toppings, String note = ''}) {
    // We'll create a unique key based on food, its selected toppings, and the note
    final toppingIds = (toppings ?? []).map((t) => t.id).toList()..sort();
    final uniqueId = '${food.id}_${toppingIds.join('_')}_${note.trim().toLowerCase()}';

    if (_items.containsKey(uniqueId)) {
      _items.update(
        uniqueId,
        (existing) => CartItem(
          food: existing.food,
          toppings: existing.toppings,
          note: existing.note,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        uniqueId,
        () => CartItem(food: food, toppings: toppings ?? [], note: note),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String uniqueId) {
    if (!_items.containsKey(uniqueId)) return;
    if (_items[uniqueId]!.quantity > 1) {
      _items.update(
        uniqueId,
        (existing) => CartItem(
          food: existing.food,
          toppings: existing.toppings,
          note: existing.note,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _items.remove(uniqueId);
    }
    notifyListeners();
  }

  void removeItem(String uniqueId) {
    _items.remove(uniqueId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
