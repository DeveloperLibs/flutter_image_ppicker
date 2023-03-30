import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_ppicker/image_picker_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePickerDialog? imagePicker;
  AnimationController? _controller;
  ImagePickerListener? _listener;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker!.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image as File);
  }

  openGallery() async {
    imagePicker!.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropImage(image as File);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller!);
    imagePicker!.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = (await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    )) as File;
    _listener!.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    imagePicker!.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
