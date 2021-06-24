import 'package:flutter/material.dart';
import 'package:foodoo/src/composition_root.dart';
import 'package:foodoo/src/foodoo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  runApp(const Foodoo());
}
