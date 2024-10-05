class Item {
  String name;

  Item({
    required this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

enum ItemType { food, beverage }
