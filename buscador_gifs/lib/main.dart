import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:buscador_gifs/ui/home_page.dart';

void main() => runApp(MaterialApp(
  home: HomePage(),
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
        hintStyle: TextStyle(color: Colors.pinkAccent),
      )),
));


