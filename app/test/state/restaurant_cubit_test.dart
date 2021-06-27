import 'package:flutter_test/flutter_test.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_state.dart';
import 'package:matcher/matcher.dart' as matcher;

import '../fixtures/fake_restaurant_api.dart';

void main() {
  late RestaurantCubit cubit;
  FakeRestaurantAPI api;

  setUp(() {
    api = FakeRestaurantAPI(20);
    cubit = RestaurantCubit(api, defaultPageSize: 10);
  });

  tearDown(() {
    cubit.close();
  });

  group('getAllRestaurants', () {
    test('returns first page with correct number of restaurants', () async {
      cubit.getAllRestaurants(currentPage: 1);

      await expectLater(
        cubit.stream,
        emits(const matcher.TypeMatcher<RestaurantPageLoadedState>()),
      );

      final RestaurantPageLoadedState state =
          cubit.state as RestaurantPageLoadedState;

      expect(state.nextPage, equals(2));
      expect(state.restaurants.length, 10);
    });

    test('returns last page with correct number of restaurants', () async {
      cubit.getAllRestaurants(currentPage: 2);

      await expectLater(
        cubit.stream,
        emits(const matcher.TypeMatcher<RestaurantPageLoadedState>()),
      );

      final RestaurantPageLoadedState state =
          cubit.state as RestaurantPageLoadedState;

      expect(state.nextPage, equals(null));
      expect(state.restaurants.length, 10);
    });
  });

  group('getRestaurant', () {
    test('returns a restaurant when found', () async {
      cubit.getRestaurant('1');

      await expectLater(
        cubit.stream,
        emits(const matcher.TypeMatcher<RestaurantLoadedState>()),
      );

      final RestaurantLoadedState state = cubit.state as RestaurantLoadedState;
      expect(state.restaurant, isNotNull);
    });

    test('returns error when restaurant is not found', () async {
      cubit.getRestaurant('-1');

      await expectLater(
        cubit.stream,
        emits(const matcher.TypeMatcher<RestaurantErrorState>()),
      );

      final RestaurantErrorState state = cubit.state as RestaurantErrorState;
      expect(state.message, isNotNull);
    });
  });
}
