import 'package:flutter/material.dart';
import 'package:foodoo/src/screens/search/search_results_screen.dart';
import 'package:restaurant/restaurant.dart';

abstract class IHomeScreenAdapter {
  void onSearchQuery(BuildContext context, String query);
  void onRestaurantSelected(BuildContext context, Restaurant restaurant);
}

class HomeScreenAdapter implements IHomeScreenAdapter {
  const HomeScreenAdapter({
    required this.onSelection,
    required this.onSearch,
  });

  final Widget Function(Restaurant restaurant) onSelection;
  final Widget Function(String query) onSearch;

  @override
  void onSearchQuery(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute<SearchResultsScreen>(builder: (_) => onSearch(query)),
    );
  }

  @override
  void onRestaurantSelected(BuildContext context, Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute<SearchResultsScreen>(
        builder: (_) => onSelection(restaurant),
      ),
    );
  }
}
