import 'package:restaurant/src/models/restaurant.dart';

class PagedResult {
  PagedResult({
    required this.currentPage,
    required this.pageSize,
    required this.restaurants,
  });

  final int currentPage;
  final int pageSize;
  final List<Restaurant> restaurants;
}
