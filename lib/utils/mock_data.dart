import '../models/food_item.dart';

final List<FoodItem> mockFoodItems = [
  FoodItem(
    id: '1',
    name: 'Juicy Burger',
    description: 'Double beef patty, cheese, lettuce, tomatoes, and secret sauce.',
    price: 12.99,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&q=80&w=800',
    category: 'Burgers',
    rating: 4.8,
    deliveryTime: '20-30 min',
  ),
  FoodItem(
    id: '2',
    name: 'Pepperoni Pizza',
    description: 'Mozzarella, tomato sauce, and pepperoni slices.',
    price: 15.50,
    imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&q=80&w=800',
    category: 'Pizza',
    rating: 4.6,
    deliveryTime: '30-40 min',
  ),
  FoodItem(
    id: '3',
    name: 'Fresh Salad',
    description: 'Mixed greens, cherry tomatoes, cucumbers, and balsamic vinaigrette.',
    price: 9.99,
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800',
    category: 'Salads',
    rating: 4.5,
    deliveryTime: '15-25 min',
  ),
  FoodItem(
    id: '4',
    name: 'Chicken Wings',
    description: 'Spicy buffalo chicken wings served with ranch dressing.',
    price: 11.00,
    imageUrl: 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?auto=format&fit=crop&q=80&w=800',
    category: 'Snacks',
    rating: 4.7,
    deliveryTime: '20-30 min',
  ),
];
