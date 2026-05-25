import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'snap_picker_theme.dart';

class SnapPickerPreview extends StatelessWidget {
  final List<XFile> images;
  final void Function(XFile image)? onRemove;

  const SnapPickerPreview({super.key, required this.images, this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final image = images[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    _FullPreviewScreen(images: images, initialIndex: index),
              ),
            );
          },
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 250),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: image.path,
                    child: Image.file(File(image.path), fit: BoxFit.cover),
                  ),

                  if (onRemove != null)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => onRemove!(image),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FullPreviewScreen extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex; 

  const _FullPreviewScreen({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_FullPreviewScreen> createState() => _FullPreviewScreenState();
}

class _FullPreviewScreenState extends State<_FullPreviewScreen> {
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
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final image = widget.images[index];

          return Center(
            child: Hero(
              tag: image.path,
              child: InteractiveViewer(
                child: Image.file(
                  File(image.path),
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
