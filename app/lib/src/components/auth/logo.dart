import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key, required this.imgPath}) : super(key: key);

  final String imgPath;

  @override
  Container build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(imgPath, fit: BoxFit.fill),
          const SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
              text: 'Food',
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold),
              children: <InlineSpan>[
                TextSpan(
                  text: 'oo',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
