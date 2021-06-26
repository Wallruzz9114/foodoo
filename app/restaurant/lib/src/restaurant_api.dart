import 'dart:convert';

import 'package:common/common.dart';
import 'package:common/models/http_result.dart';
import 'package:restaurant/src/core/adapters/i_restaurant_api.dart';
import 'package:restaurant/src/core/apis/mapper.dart';
import 'package:restaurant/src/models/location.dart';
import 'package:restaurant/src/models/paged_result.dart';
import 'package:restaurant/src/models/restaurant.dart';

class RestaurantAPI implements IRestaurantAPI {
  const RestaurantAPI({required this.client, required this.baseUrl});

  final IHttpClient client;
  final String baseUrl;

  @override
  Future<dynamic> getAllRestaurants(
      {required int page, required int pageSize}) async {
    final String endpoint = '$baseUrl/restaurants/page=$page';
    final HttpResult result = await client.get(endpoint, null);

    return _parseRestaurantResponse(result);
  }

  @override
  Future<dynamic> getMenuForRestaurant({required String restaurantId}) async {
    final String endpoint = '$baseUrl/restaurants/$restaurantId/menu';
    final HttpResult result = await client.get(endpoint, null);

    return _parseMenuResponse(result);
  }

  @override
  Future<dynamic> getRestaurant({required String restaurantId}) async {
    final String endpoint = '$baseUrl/restaurants/$restaurantId';
    final HttpResult result = await client.get(endpoint, null);

    if (result.status == Status.failure) {
      return null;
    }

    final dynamic json = jsonDecode(result.data);
    return Mapper.restaurantFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<dynamic> getRestaurantsByLocation({
    required int page,
    required int pageSize,
    required Location location,
  }) async {
    final String endpoint =
        '$baseUrl/restaurant/page=$page&longitude=${location.longitude}&latitude=${location.latitude}';
    final HttpResult result = await client.get(endpoint, null);

    return _parseRestaurantResponse(result);
  }

  @override
  Future<dynamic> findRestaurants({
    required int page,
    required int pageSize,
    required String searchTerm,
  }) async {
    final String endpoint =
        '$baseUrl/search/page=$page&limit=$pageSize&term=$searchTerm';
    final HttpResult result = await client.get(endpoint, null);

    return _parseRestaurantResponse(result);
  }

  dynamic _parseRestaurantResponse(HttpResult result) {
    if (result.status == Status.failure) {
      return null;
    }

    final Map<String, dynamic> json =
        jsonDecode(result.data) as Map<String, dynamic>;

    final dynamic restaurants = json['restaurants'] != null
        ? _getRestaurantsFromJson(json)
        : <String, dynamic>{};

    return PagedResult(
      currentPage: json['metadata']['page'] as int,
      pageSize: json['metadata']['limit'] as int,
      restaurants: restaurants as List<Restaurant>,
    );
  }

  dynamic _parseMenuResponse(HttpResult result) {
    if (result.status == Status.failure) {
      return <dynamic>[];
    }

    final Map<String, dynamic> json =
        jsonDecode(result.data) as Map<String, dynamic>;

    if (json['menu'] == null) {
      return <dynamic>[];
    }

    final List<dynamic> menu = json['menu'] as List<dynamic>;

    return menu
        .map((dynamic m) => Mapper.menuFromJson(m as Map<String, dynamic>))
        .toList();
  }

  dynamic _getRestaurantsFromJson(Map<String, dynamic> json) {
    final List<dynamic> restaurants = json['restaurants'] as List<dynamic>;
    return restaurants
        .map(
            (dynamic r) => Mapper.restaurantFromJson(r as Map<String, dynamic>))
        .toList();
  }
}
