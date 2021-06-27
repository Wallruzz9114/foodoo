import 'package:restaurant/src/models/restaurant.dart';

class PagedResult {
  PagedResult({
    required this.currentPage,
    required this.totalPages,
    required this.restaurants,
  });

  final int currentPage;
  final int totalPages;
  final List<Restaurant> restaurants;

  bool get isLast => currentPage == totalPages;
}
