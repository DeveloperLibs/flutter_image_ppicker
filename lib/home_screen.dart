import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_ppicker/image_picker_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  AnimationController _controller;


  ImagePickerDialog imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title,
        style: new TextStyle(

          color: Colors.white
        ),
        ),
      ),
      body: new GestureDetector(
        onTap: () => imagePicker.getImage(context),
        child: new Center(
          child: _image == null
              ? new Stack(
                  children: <Widget>[
                    new Center(
                      child: new CircleAvatar(
                        radius: 80.0,
                        backgroundColor: const Color(0xFF778899),
                      ),
                    ),
                    new Center(
                      child: new Image.asset("assets/photo_camera.png"),
                    ),
                  ],
                )
              : new Container(
                  height: 160.0,
                  width: 160.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: new ExactAssetImage(_image.path),
                      fit: BoxFit.cover,
                    ),
                    border:
                        Border.all(color: Colors.red, width: 5.0),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(80.0)),
                  ),
                ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=> imagePicker.getImage(context),
        tooltip: 'Increment',
        child: new Icon(Icons.photo_camera),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
}
