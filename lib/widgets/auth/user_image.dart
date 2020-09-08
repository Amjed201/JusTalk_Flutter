import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  UserImage(this.pickImageFn);

  final void Function(File pickedImage) pickImageFn;

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File _pickedImage;

  void _pickImage(bool isCamera) async {
    final pickedImageFile = await ImagePicker().getImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150);
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.pickImageFn(File(pickedImageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
          backgroundColor: Colors.grey[600],
          radius: 50,
        ),
        FlatButton.icon(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showAlertDialog(context);
              });
            },
            icon: Icon(
              Icons.image,
              color: Color(0xff058af7),
            ),
            label: Text(
              'Add Profile Image',
              style: TextStyle(color: Color(0xff058af7)),
            )),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    bool isCamera;
    // set up the buttons
    Widget cameraButton = RaisedButton.icon(
      icon: Icon(Icons.camera_alt),
      label: Text("Open Camera"),
      onPressed: () {
        isCamera=true;
        _pickImage(isCamera);

      },
    );
    Widget galleryButton = RaisedButton.icon(
      icon: Icon(Icons.image),
      label: Text("Open Gallery"),
      onPressed: () {
        isCamera=false;
        _pickImage(isCamera);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Add a profile picture",
        textAlign: TextAlign.center,
      ),
      actions: [
        cameraButton,
        galleryButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
