import 'package:restaurant/src/models/location.dart';

abstract class IRestaurantAPI {
  Future<dynamic> getAllRestaurants({
    required int page,
    required int pageSize,
  });
  Future<dynamic> getRestaurant({required String restaurantId});

  Future<dynamic> getRestaurantsByLocation({
    required int page,
    required int pageSize,
    required Location location,
  });

  Future<dynamic> findRestaurants({
    required int page,
    required int pageSize,
    required String searchTerm,
  });

  Future<dynamic> getMenuForRestaurant({required String restaurantId});
}
