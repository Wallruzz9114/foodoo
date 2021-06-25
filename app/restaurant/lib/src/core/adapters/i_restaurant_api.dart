import 'package:restaurant/src/models/location.dart';

abstract class IRestaurantAPI {
  Future<dynamic> getAllRestaurants({required int page});
  Future<dynamic> getRestaurant({required String restaurantId});

  Future<dynamic> getRestaurantsByLocation({
    required int page,
    required Location location,
  });

  Future<dynamic> findRestaurants({
    required int page,
    required String searchTerm,
  });

  Future<dynamic> getMenuForRestaurant({required String restaurantId});
}
