import 'package:flutter/material.dart';
import 'package:restaurant/restaurant.dart';

abstract class ISearchResultsScreenAdapter {
  void onRestaurantSelected(BuildContext context, Restaurant restaurant);
}

class SearchResultsScreenAdapter implements ISearchResultsScreenAdapter {
  const SearchResultsScreenAdapter({required this.onSelection});

  final Widget Function(Restaurant restaurant) onSelection;

  @override
  void onRestaurantSelected(BuildContext context, Restaurant restaurant) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => onSelection(restaurant),
      ),
    );
  }
}
