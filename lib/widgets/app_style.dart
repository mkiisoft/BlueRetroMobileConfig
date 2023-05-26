import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._();

  static TextStyle get regular => const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle get regularBold => const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get regularGray => const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static TextStyle get regularBlack => const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static TextStyle get boldBlack => const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle get boldRed => const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );

  static TextStyle regularGraySize(double size) => TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    fontSize: size,
  );

  static TextStyle boldGraySize(double size) => TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    fontSize: size,
  );

  static TextStyle regularBlackSize(double size) => TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontSize: size,
  );

  static TextStyle boldBlackSize(double size) => TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: size,
  );
}