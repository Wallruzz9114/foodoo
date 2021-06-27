import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/restaurant.dart';

class RestaurantListItem extends StatelessWidget {
  const RestaurantListItem({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  Chip _createChip(String name, BuildContext context) {
    return Chip(
      backgroundColor: Colors.black87,
      label: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Padding build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Container(
        height: 250.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                restaurant.name,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            const SizedBox(height: 12.0),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                '${restaurant.address.street}, ${restaurant.address.city}, ${restaurant.address.province} ${restaurant.address.country}',
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 8.0),
            RatingBarIndicator(
              itemBuilder: (BuildContext context, int index) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              rating: 4.5,
              itemCount: 5,
              itemSize: 50.0,
            ),
            Text('4.5', style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                _createChip('chicken', context),
                _createChip('pizza', context),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).accentColor,
              blurRadius: 0,
              offset: const Offset(5, 5),
            ),
          ],
        ),
      ),
    );
  }
}
