// ignore_for_file: prefer_const_constructors,

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagepicker = ImagePicker();
  XFile? _file = await _imagepicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    (SnackBar(
      content: Text('failed to pick image '),
    ));
  }
}
