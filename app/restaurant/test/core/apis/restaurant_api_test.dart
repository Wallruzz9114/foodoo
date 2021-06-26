import 'dart:convert';

import 'package:common/common.dart';
import 'package:common/models/http_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant/src/models/location.dart';
import 'package:restaurant/src/models/paged_result.dart';
import 'package:restaurant/src/restaurant_api.dart';

import 'restaurant_api_test.mocks.dart';

@GenerateMocks(<Type>[IHttpClient, http.Client])
void main() {
  late MockIHttpClient client;
  late RestaurantAPI api;

  setUp(() {
    client = MockIHttpClient();
    api = RestaurantAPI(client: client, baseUrl: 'http:baseUrl');
  });

  group('getAllRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
            data: jsonEncode(<String, dynamic>{
              'metadata': <String, dynamic>{'page': 1, 'limit': 2},
              'restaurants': <dynamic>[]
            }),
            status: Status.success),
      );

      final dynamic results = await api.getAllRestaurants(page: 1, pageSize: 2);
      expect((results as PagedResult).restaurants, <dynamic>[]);
    });

    test('returns an empty list when response status is not 200', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(<String, dynamic>{}),
          status: Status.failure,
        ),
      );

      final dynamic results = await api.getAllRestaurants(page: 1, pageSize: 2);
      expect(results, isNull);
    });

    test('returns a list of restaurants (successful request)', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(_restaurantsJson()),
          status: Status.success,
        ),
      );

      final dynamic results = await api.getAllRestaurants(page: 1, pageSize: 2);
      expect((results as PagedResult).restaurants.length, 2);
    });
  });

  group('getRestaurant', () {
    test('returns null when the restaurant is not found', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(<String, String>{'error': 'restaurant not found'}),
          status: Status.failure,
        ),
      );

      final dynamic result = await api.getRestaurant(restaurantId: '1234');
      expect(result, null);
    });

    test('return restaurant when correct id is provided', () async {
      when(client.get(any, null)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restaurantsJson()['restaurants'][0]),
          status: Status.success));

      final dynamic result = await api.getRestaurant(restaurantId: '12345');

      expect(result, isNotNull);
      expect(result.id, '12345');
    });
  });

  group('getRestaurantsByLocation', () {
    test('returns an empty list when no restaurants are found', () async {
      when(client.get(any, null)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(<String, dynamic>{
            'metadata': <String, dynamic>{'page': 1, 'limit': 2},
            'restaurants': <dynamic>[]
          }),
          status: Status.success));
      final dynamic results = await api.getRestaurantsByLocation(
        page: 1,
        pageSize: 2,
        location: const Location(longitude: 1233, latitude: 12.45),
      );

      expect((results as PagedResult).restaurants, <dynamic>[]);
    });

    test('returns list of restaurants when success', () async {
      when(client.get(any, null)).thenAnswer((_) async => HttpResult(
          data: jsonEncode(_restaurantsJson()), status: Status.success));
      final dynamic results = await api.getRestaurantsByLocation(
        page: 1,
        pageSize: 2,
        location: const Location(longitude: 1233, latitude: 12.45),
      );

      expect((results as PagedResult).restaurants.length, 2);
    });
  });

  group('findRestaurants', () {
    test('returns an empty list when no restaurants are found', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(<String, dynamic>{
            'metadata': <String, dynamic>{'page': 1, 'limit': 2},
            'restaurants': <dynamic>[]
          }),
          status: Status.success,
        ),
      );

      final dynamic results = await api.findRestaurants(
          page: 1, pageSize: 2, searchTerm: 'yucayic');
      expect((results as PagedResult).restaurants, <dynamic>[]);
    });

    test('returns list of restaurants when success', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(_restaurantsJson()),
          status: Status.success,
        ),
      );

      final dynamic results =
          await api.findRestaurants(page: 1, pageSize: 2, searchTerm: 'tdud');

      expect((results as PagedResult).restaurants.length, 2);
    });
  });

  group('getRestaurantMenu', () {
    test('returns empty list when no menu is found', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(<String, dynamic>{'menu': <dynamic>[]}),
          status: Status.failure,
        ),
      );
      final dynamic result =
          await api.getMenuForRestaurant(restaurantId: '12345');
      expect(result, <dynamic>[]);
    });

    test('returns restaurant menu when success', () async {
      when(client.get(any, null)).thenAnswer(
        (_) async => HttpResult(
          data: jsonEncode(<String, dynamic>{'menu': _restaurantMenuJson()}),
          status: Status.success,
        ),
      );

      final dynamic result =
          await api.getMenuForRestaurant(restaurantId: '12345');

      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result.first.id, '12345');
    });
  });
}

dynamic _restaurantsJson() {
  return <String, dynamic>{
    'metadata': <String, dynamic>{'page': 1, 'limit': 2},
    'restaurants': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '12345',
        'name': 'Restuarant Name',
        'type': 'Fast Food',
        'image_url': 'restaurant.jpg',
        'location': <String, double>{'longitude': 345.33, 'latitude': 345.23},
        'address': <String, String>{
          'street': 'Road 1',
          'city': 'Vancouver',
          'province': 'BC',
          'country': 'Canada'
        }
      },
      <String, dynamic>{
        'id': '12666',
        'name': 'Restuarant Name',
        'type': 'Fast Food',
        'image_url': 'restaurant.jpg',
        'location': <String, double>{'longitude': 345.33, 'latitude': 345.23},
        'address': <String, String>{
          'street': 'Road 1',
          'city': 'Toronto',
          'province': 'ON',
          'country': 'Canada'
        }
      }
    ]
  };
}

dynamic _restaurantMenuJson() {
  return <Map<String, dynamic>>[
    <String, dynamic>{
      'id': '12345',
      'name': 'Lunch',
      'description': 'a fun menu',
      'image_url': 'menu.jpg',
      'items': <dynamic>[
        <String, dynamic>{
          'name': 'nuff food',
          'description': 'awasome!!',
          'image_urls': <String>['url1', 'url2'],
          'unit_price': 12.99
        },
        <String, dynamic>{
          'name': 'nuff food',
          'description': 'awasome!!',
          'image_urls': <String>['url1', 'url2'],
          'unit_price': 12.99
        }
      ]
    }
  ];
}
