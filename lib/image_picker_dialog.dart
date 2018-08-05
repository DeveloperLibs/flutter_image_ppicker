import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  ImagePickerListener _view;
  AnimationController _controller;
  BuildContext context;

  ImagePickerDialog(
      ImagePickerListener this._view, AnimationController this._controller);

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
            position: _drawerDetailsPosition,
            child: new FadeTransition(
              opacity: new ReverseAnimation(_drawerContentsOpacity),
              child: this,
            ),
          ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    dismissDialog(BuildContext context) {
      _controller.reverse();
      startTime();
    }

    openGallery(BuildContext context) async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      cropImage(image);
    }

    openCamera(BuildContext context) async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      cropImage(image);
    }

    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new GestureDetector(
                  onTap: () => openCamera(context),
                  child: buttonWithColorBg(
                      "Camera",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF167F67),
                      const Color(0xFFFFFFFF)),
                ),
                new GestureDetector(
                  onTap: () => openGallery(context),
                  child: buttonWithColorBg(
                      "Gallery",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF167F67),
                      const Color(0xFFFFFFFF)),
                ),
                const SizedBox(height: 15.0),
                new GestureDetector(
                  onTap: () => dismissDialog(context),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: buttonWithColorBg(
                        "Cancel",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        const Color(0xFF167F67),
                        const Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buttonWithColorBg(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    _view.userImage(croppedFile);
    Navigator.pop(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
