import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class Utils {
  static Image imageFromBase64String(String base64String,
      {double width = 250.0, double height = 250.0}) {
    Image? image;
    try {
      image = Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
    } catch (e) {
      image = Image.asset('assets/images/broken_photo.png');
    }

    return image;
  }


  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Color getBackgroundColor(int seed) {
    return HSLColor.fromAHSL(
            1.0, Random(seed).nextInt(360).toDouble(), 1.0, 0.5)
        .toColor();
  }

  static getInitials(String str) {
    if (str.trim().isEmpty) {
      return '?';
    }
    // Replace all multiple spaces with a single space.
    str = str.replaceAll(RegExp(r'\s+'), ' ');

    // var words = str.split(' ');
    var words = str.split(' ').where((word) => word.isNotEmpty).toList();

    if (words.length == 1) {
      return words[0][0];
    }
    return words[0][0] + words.last[0];
  }
}
