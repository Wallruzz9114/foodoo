import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodoo/src/components/helpers.dart';
import 'package:foodoo/src/screens/search/search_results_screen_adapter.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    Key? key,
    required this.restaurantCubit,
    required this.query,
    required this.adapter,
  }) : super(key: key);

  final RestaurantCubit restaurantCubit;
  final String query;
  final ISearchResultsScreenAdapter adapter;

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Restaurant> restaurants = <Restaurant>[];
  bool fetchMore = false;
  RestaurantState currentState = const RestaurantIntitialState();
  final ScrollController _scrollController = ScrollController();

  ListView _buildResultsList() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return index >= restaurants.length
            ? bottomLoader()
            : Material(
                child: InkWell(
                  onTap: () => widget.adapter.onRestaurantSelected(
                    context,
                    restaurants[index],
                  ),
                  child: ListTile(
                    leading: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: 'https://picsum.photos/id/292/300',
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          restaurants[index].name,
                          style: Theme.of(context).textTheme.subtitle1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        RatingBarIndicator(
                          rating: 4.5,
                          itemBuilder: (BuildContext context, int index) =>
                              const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          itemSize: 25.0,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      '${restaurants[index].address.street}, ${restaurants[index].address.city}, ${restaurants[index].address.country}',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              );
      },
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      separatorBuilder: (_, int index) => const Divider(),
      itemCount: !fetchMore ? restaurants.length : restaurants.length + 1,
    );
  }

  BlocBuilder<RestaurantCubit, RestaurantState> _buildResults() {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      bloc: widget.restaurantCubit,
      builder: (_, RestaurantState state) {
        if (state is RestaurantPageLoadedState) {
          currentState = state;
          fetchMore = false;
          restaurants.addAll(state.restaurants);
        }

        if (state is RestaurantErrorState) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          );
        }

        if (currentState is RestaurantIntitialState || currentState == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildResultsList();
      },
    );
  }

  void _onScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          (currentState as RestaurantPageLoadedState).nextPage != null) {
        fetchMore = true;
        widget.restaurantCubit.search(
            (currentState as RestaurantPageLoadedState).nextPage!,
            widget.query);
      }
    });
  }

  @override
  void initState() {
    widget.restaurantCubit.search(1, widget.query);
    super.initState();
    _onScrollListener();
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          iconSize: 30.0,
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${widget.query} Results',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }
}
