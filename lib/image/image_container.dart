import 'dart:io';
import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  final File? img;

  const ImageContainer({Key? key, this.img}) : super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          image: widget.img == null
              ? null
              : DecorationImage(
            image: FileImage(widget.img!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}