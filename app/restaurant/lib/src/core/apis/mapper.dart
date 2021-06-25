import 'package:restaurant/src/models/address.dart';
import 'package:restaurant/src/models/location.dart';
import 'package:restaurant/src/models/menu.dart';
import 'package:restaurant/src/models/menu_item.dart';
import 'package:restaurant/src/models/restaurant.dart';

class Mapper {
  static Restaurant restaurantFromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        displayImgUrl: json['image_url'] ?? '',
        location: Location(
          latitude: json['location']['latitude'] as double,
          longitude: json['location']['longitude'] as double,
        ),
        address: Address(
          street: json['address']['street'] as String,
          city: json['address']['city'] as String,
          province: json['address']['province'] as String,
          country: json['address']['country'] as String,
        ),
      );

  static Menu menuFromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      displayImgUrl: json['image_url'] ?? '',
      items: (json['items'] as List<dynamic>) != null
          ? (json['items'] as List<dynamic>)
              .map(
                (dynamic item) => MenuItem(
                    name: item['name'] as String,
                    imageUrls:
                        item['image_urls'].cast<String>() as List<String>,
                    description: item['description'] as String,
                    unitPrice: item['unit_price'] as double),
              )
              .toList()
          : <MenuItem>[],
    );
  }
}
