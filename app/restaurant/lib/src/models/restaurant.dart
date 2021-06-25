import 'package:restaurant/src/models/address.dart';
import 'package:restaurant/src/models/location.dart';

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.displayImgUrl,
    required this.type,
    required this.location,
    required this.address,
  });

  final String id;
  final String name;
  final dynamic displayImgUrl;
  final String type;
  final Location location;
  final Address address;
}
