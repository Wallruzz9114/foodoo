import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Size size;
  final void Function() onPressed;

  @override
  ElevatedButton build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        onPrimary: Theme.of(context).accentColor,
        elevation: 0,
        minimumSize: size,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Container(
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button!
              .copyWith(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}
