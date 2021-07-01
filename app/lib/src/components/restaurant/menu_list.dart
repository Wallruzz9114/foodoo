import 'package:flutter/material.dart';
import 'package:foodoo/src/components/helpers.dart';
import 'package:foodoo/src/components/shared/custom_button.dart';
import 'package:restaurant/restaurant.dart';
import 'package:transparent_image/transparent_image.dart';

class MenuList extends StatefulWidget {
  const MenuList({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  final List<MenuItem> menuItems;

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList>
    with AutomaticKeepAliveClientMixin {
  @override
  ListView build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () => displayAddToBasket(context, widget.menuItems[index]),
            child: ListTile(
              isThreeLine: false,
              leading: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/id/292/300',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.menuItems[index].name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Text(
                    doubleToCurrency(widget.menuItems[index].unitPrice),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              subtitle: Text(
                widget.menuItems[index].description,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _, int index) => const Divider(),
      itemCount: widget.menuItems.length,
    );
  }

  void displayAddToBasket(BuildContext context, MenuItem menuItem) {
    showModalBottomSheet<Padding>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      context: context,
      builder: (BuildContext context) => Container(
        height: 160,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16,
            bottom: 20.0,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      menuItem.name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Text(
                    doubleToCurrency(menuItem.unitPrice),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.black26,
                    ),
                  ),
                  Text(
                    '1',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              CustomButton(
                onPressed: () {},
                text: 'Add to Basket',
                size: const Size(double.infinity, 45),
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
