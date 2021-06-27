import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/state/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit(this._api, {int defaultPageSize = 30})
      : _pageSize = defaultPageSize,
        super(const RestaurantIntitialState());

  final IRestaurantAPI _api;
  final int _pageSize;

  Future<void> getAllRestaurants({required int currentPage}) async {
    _startLoading();

    final dynamic pagedResult = await _api.getAllRestaurants(
      currentPage: currentPage,
      totalPages: _pageSize,
    );

    pagedResult == null || (pagedResult as PagedResult).restaurants.isEmpty
        ? _showError('no restaurant found')
        : _setPageData(pagedResult);
  }

  Future<dynamic> getRestaurantsByLocation(
    int currentPage,
    Location location,
  ) async {
    _startLoading();
    final dynamic pagedResult = await _api.getRestaurantsByLocation(
      currentPage: currentPage,
      totalPages: _pageSize,
      location: location,
    );

    pagedResult == null || (pagedResult as PagedResult).restaurants.isEmpty
        ? _showError('no restaurant found')
        : _setPageData(pagedResult);
  }

  Future<dynamic> search(int currentPage, String searchQuery) async {
    _startLoading();
    final dynamic searchResults = _api.findRestaurants(
      currentPage: currentPage,
      totalPages: _pageSize,
      searchTerm: searchQuery,
    );

    searchResults == null || (searchResults as PagedResult).restaurants.isEmpty
        ? _showError('no restaurant found')
        : _setPageData(searchResults);
  }

  Future<dynamic> getMenuForRestaurant(String restaurantId) async {
    _startLoading();
    final dynamic menu =
        await _api.getMenuForRestaurant(restaurantId: restaurantId);

    menu != null
        ? emit(RestaurantMenuLoadedState(menu as List<Menu>))
        : emit(const RestaurantErrorState('No menu found for this restaurant'));
  }

  Future<dynamic> getRestaurant(String restaurantId) async {
    _startLoading();
    final dynamic restaurant =
        await _api.getRestaurant(restaurantId: restaurantId);

    restaurant != null
        ? emit(RestaurantLoadedState(restaurant as Restaurant))
        : emit(const RestaurantErrorState('restaurant not found'));
  }

  void _startLoading() {
    emit(const RestaurantLoadingState());
  }

  void _showError(String message) {
    emit(RestaurantErrorState(message));
  }

  void _setPageData(PagedResult pagedResult) {
    emit(RestaurantPageLoadedState(pagedResult));
  }
}
