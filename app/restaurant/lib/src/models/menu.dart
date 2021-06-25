import 'package:restaurant/src/models/menu_item.dart';

class Menu {
  Menu({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    this.displayImgUrl,
  });

  final String id;
  final String name;
  final String description;
  dynamic displayImgUrl;
  final List<MenuItem> items;
}
