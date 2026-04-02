import 'package:flutter/material.dart';
import '../models/food_item.dart';

class FavoritesProvider with ChangeNotifier {
  final List<FoodItem> _favoriteItems = [];

  List<FoodItem> get items => [..._favoriteItems];

  int get itemCount => _favoriteItems.length;

  bool isFavorite(String foodId) {
    return _favoriteItems.any((item) => item.id == foodId);
  }

  void toggleFavorite(FoodItem food) {
    final index = _favoriteItems.indexWhere((item) => item.id == food.id);
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(food);
    }
    notifyListeners();
  }

  void removeFavorite(String foodId) {
    _favoriteItems.removeWhere((item) => item.id == foodId);
    notifyListeners();
  }
}
