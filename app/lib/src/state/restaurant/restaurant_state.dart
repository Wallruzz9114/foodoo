import 'package:equatable/equatable.dart';
import 'package:restaurant/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
}

class RestaurantIntitialState extends RestaurantState {
  const RestaurantIntitialState();

  @override
  List<Object> get props => <Object>[];
}

class RestaurantLoadingState extends RestaurantState {
  const RestaurantLoadingState();

  @override
  List<Object> get props => <Object>[];
}

class RestaurantPageLoadedState extends RestaurantState {
  const RestaurantPageLoadedState(this._pagedResult);

  final PagedResult _pagedResult;
  List<Restaurant> get restaurants => _pagedResult.restaurants;
  int? get nextPage =>
      _pagedResult.isLast ? null : _pagedResult.currentPage + 1;

  @override
  List<Object> get props => <Object>[_pagedResult];
}

class RestaurantLoadedState extends RestaurantState {
  const RestaurantLoadedState(this.restaurant);

  final Restaurant restaurant;

  @override
  List<Object> get props => <Object>[restaurant];
}

class RestaurantMenuLoadedState extends RestaurantState {
  const RestaurantMenuLoadedState(this.menus);

  final List<Menu> menus;

  @override
  List<Object> get props => <Object>[menus];
}

class RestaurantErrorState extends RestaurantState {
  const RestaurantErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => <Object>[message];
}
