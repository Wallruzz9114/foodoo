import 'package:restaurant/src/models/location.dart';

abstract class IRestaurantAPI {
  Future<dynamic> getAllRestaurants({
    required int currentPage,
    required int totalPages,
  });

  Future<dynamic> getRestaurant({required String restaurantId});

  Future<dynamic> getRestaurantsByLocation({
    required int currentPage,
    required int totalPages,
    required Location location,
  });

  Future<dynamic> findRestaurants({
    required int currentPage,
    required int totalPages,
    required String searchTerm,
  });

  Future<dynamic> getMenuForRestaurant({required String restaurantId});
}
