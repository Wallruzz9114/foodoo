import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodoo/src/components/restaurant/restaurant_list_item.dart';
import 'package:foodoo/src/components/shared/custom_text_field.dart';
import 'package:foodoo/src/models/custom_header.dart';
import 'package:foodoo/src/state/helpers/custom_header_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantsListScreen extends StatefulWidget {
  const RestaurantsListScreen({Key? key}) : super(key: key);

  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  RestaurantPageLoadedState? pageLoadedState;
  List<Restaurant> restaurants = <Restaurant>[];
  double currentIndex = 0;
  double previousIndex = 0;
  final ScrollController _scrollController = ScrollController();

  Stack _bulidCustomHeader(CustomHeader customHeader) {
    return Stack(
      children: <Widget>[
        FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: 'https://picsum.photos/id/292/300',
          height: 350.0,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(color: Theme.of(context).accentColor.withOpacity(0.7)),
        Align(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
              child: Text(
                customHeader.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _header() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
      height: 350.0,
      child: Stack(
        children: <Widget>[
          BlocBuilder<CustomHeaderCubit, CustomHeader>(
            builder: (_, CustomHeader header) => _bulidCustomHeader(header),
          ),
          Align(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
              child: CustomTextField(
                hint: 'Find restaurants',
                fontSize: 14.0,
                height: 48.0,
                fontWeight: FontWeight.normal,
                onChanged: (String value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateHeader() {
    final Restaurant restaurant = restaurants[currentIndex.toInt()];
    BlocProvider.of<CustomHeaderCubit>(context).update(
      restaurant.type,
      restaurant.displayImgUrl as String,
    );
  }

  Container _bottomLoader() {
    return Container(
      alignment: Alignment.center,
      child: const Center(
        child: SizedBox(
          width: 33.0,
          height: 33.0,
          child: CircularProgressIndicator(strokeWidth: 1.5),
        ),
      ),
    );
  }

  NotificationListener<ScrollEndNotification> _buildListOfRestaurants() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        if (currentIndex != previousIndex) {
          _updateHeader();
          previousIndex = currentIndex;
        }
        return true;
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return index >= restaurants.length
              ? _bottomLoader()
              : RestaurantListItem(restaurant: restaurants[index]);
        },
        physics: const BouncingScrollPhysics(),
        itemCount: pageLoadedState!.nextPage == null
            ? restaurants.length
            : restaurants.length + 1,
        controller: _scrollController,
      ),
    );
  }

  void _onScrollListener() {
    _scrollController.addListener(() {
      currentIndex = (_scrollController.offset.round() / 240).floorToDouble();
      if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent &&
          pageLoadedState!.nextPage != null) {
        BlocProvider.of<RestaurantCubit>(context)
            .getAllRestaurants(currentPage: pageLoadedState!.nextPage!);
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<RestaurantCubit>(context).getAllRestaurants(currentPage: 1);
    super.initState();
    _onScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_basket_outlined, size: 38.8),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(child: _header(), alignment: Alignment.topCenter),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.75,
              child: BlocConsumer<RestaurantCubit, RestaurantState>(
                builder: (_, RestaurantState state) {
                  if (state is RestaurantPageLoadedState) {
                    pageLoadedState = state;
                    restaurants.addAll(state.restaurants);
                    _updateHeader();
                  }
                  if (pageLoadedState == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildListOfRestaurants();
                },
                listener: (BuildContext context, RestaurantState state) {
                  if (state is RestaurantErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
