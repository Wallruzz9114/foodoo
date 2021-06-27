import 'package:faker/faker.dart' as ff;
import 'package:restaurant/restaurant.dart';
import 'package:restaurant/src/models/location.dart';

class FakeRestaurantAPI implements IRestaurantAPI {
  FakeRestaurantAPI(int count) {
    final ff.Faker faker = ff.Faker();

    _restaurants = List<Restaurant>.generate(
      count,
      (int index) => Restaurant(
        id: index.toString(),
        name: faker.company.name(),
        type: faker.food.cuisine(),
        displayImgUrl: faker.internet.httpUrl(),
        address: Address(
          street: faker.address.streetName(),
          city: faker.address.city(),
          province: faker.address.state(),
          country: faker.address.country(),
        ),
        location: Location(
          longitude: faker.randomGenerator.integer(5).toDouble(),
          latitude: faker.randomGenerator.integer(5).toDouble(),
        ),
      ),
    );

    for (final Restaurant restaurant in _restaurants) {
      final List<Menu> menus = List<Menu>.generate(
        faker.randomGenerator.integer(5),
        (int index) => Menu(
          id: restaurant.id,
          name: faker.food.dish(),
          description: faker.lorem.sentences(2).join(),
          items: List<MenuItem>.generate(
            faker.randomGenerator.integer(15),
            (_) => MenuItem(
              name: faker.food.dish(),
              description: faker.lorem.sentence(),
              unitPrice:
                  faker.randomGenerator.integer(5000, min: 500).toDouble(),
            ),
          ),
        ),
      );
      _menus.addAll(menus);
    }
  }

  late List<Restaurant> _restaurants;
  late final List<Menu> _menus = <Menu>[];

  @override
  Future<dynamic> findRestaurants({
    required int currentPage,
    required int totalPages,
    required String searchTerm,
  }) async {
    final dynamic filter = searchTerm != null
        ? (Restaurant res) => res.name.contains(searchTerm)
        : null;
    return _paginatedRestaurants(
      currentPage,
      totalPages,
      filter: filter as bool Function(Restaurant),
    );
  }

  @override
  Future<dynamic> getAllRestaurants({
    required int currentPage,
    required int totalPages,
  }) async {
    return _paginatedRestaurants(currentPage, totalPages);
  }

  @override
  Future<dynamic> getMenuForRestaurant({required String restaurantId}) async {
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    return _menus.where((Menu menu) => menu.id == restaurantId).toList();
  }

  @override
  Future<dynamic> getRestaurant({required String restaurantId}) async {
    return _restaurants
        .singleWhereOrNull((Restaurant res) => res.id == restaurantId);
  }

  @override
  Future<dynamic> getRestaurantsByLocation({
    required int currentPage,
    required int totalPages,
    required Location location,
  }) async {
    final dynamic filter =
        location != null ? (Restaurant res) => res.location == location : null;

    return _paginatedRestaurants(
      currentPage,
      totalPages,
      filter: filter as bool Function(Restaurant),
    );
  }

  PagedResult _paginatedRestaurants(
    int currentPage,
    int pageSize, {
    bool Function(Restaurant)? filter,
  }) {
    final int offset = (currentPage - 1) * pageSize;
    final List<Restaurant> restaurants =
        filter == null ? _restaurants : _restaurants.where(filter).toList();
    final int totalPages = (restaurants.length / pageSize).ceil();

    final dynamic result = restaurants.skip(offset).take(pageSize).toList();

    return PagedResult(
      currentPage: currentPage,
      totalPages: totalPages,
      restaurants: result as List<Restaurant>,
    );
  }
}

extension SingleWhereOrNullExtension<E> on Iterable<E> {
  E? singleWhereOrNull(bool Function(E) test) {
    for (final E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
