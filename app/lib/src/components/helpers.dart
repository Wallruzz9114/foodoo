import 'package:flutter/material.dart';

Container bottomLoader() {
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
