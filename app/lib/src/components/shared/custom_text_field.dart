import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.hint,
    required this.fontSize,
    this.height = 54.0,
    required this.fontWeight,
    required this.onChanged,
  }) : super(key: key);

  final String hint;
  final double fontSize;
  final double height;
  final FontWeight fontWeight;
  final Function(String value) onChanged;

  @override
  Container build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        onChanged: onChanged,
        cursorColor: Colors.black,
        style: Theme.of(context).textTheme.overline!.copyWith(
              color: Colors.black,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black, fontSize: fontSize),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).accentColor,
            blurRadius: 0,
            offset: const Offset(5, 5),
          ),
        ],
      ),
    );
  }
}
