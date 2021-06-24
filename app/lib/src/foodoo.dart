import 'package:flutter/material.dart';
import 'package:foodoo/src/composition_root.dart';
import 'package:google_fonts/google_fonts.dart';

class Foodoo extends StatelessWidget {
  const Foodoo({Key? key}) : super(key: key);

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodoo',
      theme: ThemeData(
        accentColor: const Color.fromARGB(255, 251, 176, 59),
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CompositionRoot.composeAuthUI(),
    );
  }
}
