import 'package:flutter/material.dart';

Future<T> loadPage<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}
