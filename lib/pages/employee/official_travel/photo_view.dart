import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:arzayahrd/services/api_clien.dart';

class PhotoViewPages extends StatefulWidget {
  PhotoViewPages({this.image_url, this.iamge_file});

  var image_url, iamge_file;

  @override
  State<PhotoViewPages> createState() => _PhotoViewPagesState();
}

class _PhotoViewPagesState extends State<PhotoViewPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Hero(
            tag: "avatar-1",
            child: Container(
              child: widget.image_url != ""
                  ? PhotoView(
                      imageProvider: NetworkImage(
                      "${image_ur}/${widget.image_url}",
                    ))
                  : widget.iamge_file != ""
                      ? Image.file(File(widget.iamge_file))
                      : PhotoView(
                          imageProvider: NetworkImage(
                            "${image_ur}/${widget.image_url}",
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
