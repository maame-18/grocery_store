enum SelectionType { checkbox, radio }

class Topping {
  final String id;
  final String name;
  final double price;
  final SelectionType type;
  final String category;

  const Topping({
    required this.id,
    required this.name,
    this.price = 0.0,
    this.type = SelectionType.checkbox,
    required this.category,
  });
}
