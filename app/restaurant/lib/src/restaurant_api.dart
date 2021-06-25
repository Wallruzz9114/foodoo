import 'dart:convert';

import 'package:http/http.dart';
import 'package:restaurant/src/core/adapters/i_restaurant_api.dart';
import 'package:restaurant/src/core/apis/mapper.dart';
import 'package:restaurant/src/models/location.dart';

class RestaurantAPI implements IRestaurantAPI {
  const RestaurantAPI({required this.client, required this.baseUrl});

  final Client client;
  final String baseUrl;

  @override
  Future<dynamic> getAllRestaurants({required int page}) async {
    final String endpoint = '$baseUrl/restaurants/page=$page';
    final Uri uri = Uri.parse(endpoint);
    final Response response = await client.get(uri);

    return _parseRestaurantResponse(response);
  }

  @override
  Future<dynamic> getMenuForRestaurant({required String restaurantId}) async {
    final String endpoint = '$baseUrl/restaurants/$restaurantId/menu';
    final Uri uri = Uri.parse(endpoint);
    final Response response = await client.get(uri);

    return _parseMenuResponse(response);
  }

  @override
  Future<dynamic> getRestaurant({required String restaurantId}) async {
    final String endpoint = '$baseUrl/restaurants/$restaurantId';
    final Uri uri = Uri.parse(endpoint);
    final Response response = await client.get(uri);

    if (response.statusCode != 200) {
      return null;
    }

    final dynamic json = jsonDecode(response.body);
    return Mapper.restaurantFromJson(json as Map<String, dynamic>);
  }

  @override
  Future<dynamic> getRestaurantsByLocation({
    required int page,
    required Location location,
  }) async {
    final String endpoint =
        '$baseUrl/restaurant/page=$page&longitude=${location.longitude}&latitude=${location.latitude}';
    final Uri uri = Uri.parse(endpoint);
    final Response response = await client.get(uri);

    return _parseRestaurantResponse(response);
  }

  @override
  Future<dynamic> findRestaurants({
    required int page,
    required String searchTerm,
  }) async {
    final String endpoint = '$baseUrl/search/page=$page&term=$searchTerm';
    final Uri uri = Uri.parse(endpoint);
    final Response response = await client.get(uri);

    return _parseRestaurantResponse(response);
  }

  dynamic _parseRestaurantResponse(Response response) {
    if (response.statusCode != 200) {
      return <dynamic>[];
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    return json['restaurants'] != null
        ? _getRestaurantsFromJson(json)
        : <String, dynamic>{};
  }

  dynamic _parseMenuResponse(Response response) {
    if (response.statusCode != 200) {
      return <dynamic>[];
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;

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
