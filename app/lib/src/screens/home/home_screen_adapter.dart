import 'package:flutter/material.dart';
import 'package:foodoo/src/screens/search/search_results_screen.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';

abstract class IHomeScreenAdapter {
  void onSearchQuery(BuildContext context, String query);
}

class HomeScreenAdapter implements IHomeScreenAdapter {
  const HomeScreenAdapter(this._restaurantCubit);

  final RestaurantCubit _restaurantCubit;

  @override
  void onSearchQuery(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute<SearchResultsScreen>(
        builder: (_) => SearchResultsScreen(
          restaurantCubit: _restaurantCubit,
          query: query,
        ),
      ),
    );
  }
}
