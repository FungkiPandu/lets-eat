import 'package:flutter_test/flutter_test.dart';
import 'package:lets_eat/data/models/restaurant.dart';

void main() {
  test("Restaurant to Json", () {
    const restaurant = Restaurant(
      id: "rqdv5juczeskfw1e867",
      name: "Melting Pot",
      description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
      pictureId: "14",
      city: "Medan",
      rating: 4.2,
    );

    final data = restaurant.toJson();

    expect(data["id"], "rqdv5juczeskfw1e867");
    expect(data["name"], "Melting Pot");
    expect(data["description"],
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.");
    expect(data["pictureId"], "14");
    expect(data["city"], "Medan");
    expect(data["rating"], 4.2);
  });

  test("Restaurant from Json", () {
    const map = {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description":
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
      "pictureId": "14",
      "city": "Medan",
      "rating": 4.2
    };

    final restaurant = Restaurant.fromJson(map);

    expect(restaurant.id, "rqdv5juczeskfw1e867");
    expect(restaurant.name, "Melting Pot");
    expect(restaurant.description,
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.");
    expect(restaurant.pictureId, "14");
    expect(restaurant.city, "Medan");
    expect(restaurant.rating, 4.2);
  });
}
