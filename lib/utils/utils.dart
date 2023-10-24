import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class Utils {
  static Image imageFromBase64String(String base64String,
      {double width = 150.0, double height = 150.0}) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
