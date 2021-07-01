import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodoo/src/components/restaurant/menu_list.dart';
import 'package:foodoo/src/state/restaurant/restaurant_cubit.dart';
import 'package:foodoo/src/state/restaurant/restaurant_state.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({
    Key? key,
    required this.restaurant,
    required this.restaurantCubit,
  }) : super(key: key);

  final Restaurant restaurant;
  final RestaurantCubit restaurantCubit;

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  List<Menu> menus = <Menu>[];

  FractionallySizedBox _header() {
    return FractionallySizedBox(
      heightFactor: 0.44,
      child: Stack(
        children: <Widget>[
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: 'https://picsum.photos/id/292/300',
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Container(
                height: 120.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).accentColor,
                      blurRadius: 0,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 12.0,
                      ),
                      child: Text(
                        widget.restaurant.name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Text(
                        '${widget.restaurant.address.street}, ${widget.restaurant.address.city}, ${widget.restaurant.address.province} ${widget.restaurant.address.country}',
                        softWrap: true,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RatingBarIndicator(
                          itemBuilder: (BuildContext context, int index) {
                            return const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            );
                          },
                          rating: 4.5,
                          itemCount: 5,
                          itemSize: 30.0,
                          direction: Axis.horizontal,
                        ),
                        Text('(4.5)', style: Theme.of(context).textTheme.button)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DefaultTabController _buildMenuList() {
    return DefaultTabController(
      length: menus.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
            isScrollable: true,
            labelColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
            labelStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
            tabs: menus
                .map<Widget>(
                  (Menu m) => Tab(
                    text: m.name,
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: menus
                  .map<Widget>(
                    (Menu menu) => MenuList(menuItems: menu.items),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  FractionallySizedBox _menu() {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: BlocBuilder<RestaurantCubit, RestaurantState>(
        bloc: widget.restaurantCubit,
        builder: (_, RestaurantState state) {
          if (state is RestaurantLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantErrorState) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            );
          }

          if (state is RestaurantMenuLoadedState) {
            menus.addAll(state.menus);
          }

          return _buildMenuList();
        },
      ),
    );
  }

  @override
  void initState() {
    widget.restaurantCubit.getMenuForRestaurant(widget.restaurant.id);
    super.initState();
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 30.0,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_basket),
            iconSize: 30.0,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(child: _menu(), alignment: Alignment.bottomLeft),
          Align(child: _header(), alignment: Alignment.topCenter),
        ],
      ),
    );
  }
}
