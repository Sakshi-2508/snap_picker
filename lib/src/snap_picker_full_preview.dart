import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SnapPickerFullPreview extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;

  const SnapPickerFullPreview({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<SnapPickerFullPreview> createState() => _SnapPickerFullPreviewState();
}

class _SnapPickerFullPreviewState extends State<SnapPickerFullPreview> {
  late final PageController _controller;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${currentIndex + 1}/${widget.images.length}'),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Hero(
                tag: widget.images[index].path,
                child: Image.file(
                  File(widget.images[index].path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
