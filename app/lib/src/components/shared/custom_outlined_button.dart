import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;
  final Widget icon;
  final Size size;
  final String text;

  @override
  SizedBox build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          primary: Colors.black,
          minimumSize: const Size(88, 36),
          shape: const StadiumBorder(
            side: BorderSide(width: 1.5, color: Colors.black),
          ),
        ).copyWith(
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                );
              return const BorderSide();
            },
          ),
        ),
        onPressed: onPressed,
        icon: icon,
        label: Text(
          text,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}
