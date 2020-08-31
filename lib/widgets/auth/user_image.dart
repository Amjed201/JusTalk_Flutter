import 'dart:io';
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

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
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
            onPressed: _pickImage,
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
}
