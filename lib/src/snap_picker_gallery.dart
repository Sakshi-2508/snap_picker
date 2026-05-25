import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class SnapPickerGallery extends StatefulWidget {
  final bool allowMultiple;
  final int maxSelection;
  final ValueChanged<List<AssetEntity>> onDone;

  const SnapPickerGallery({
    super.key,
    required this.allowMultiple,
    required this.maxSelection,
    required this.onDone,
  });

  @override
  State<SnapPickerGallery> createState() => _SnapPickerGalleryState();
}

class _SnapPickerGalleryState extends State<SnapPickerGallery> {
  final List<AssetEntity> _assets = [];
  final List<AssetEntity> _selected = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final permission = await PhotoManager.requestPermissionExtend();

    if (!permission.isAuth) {
      setState(() => _loading = false);
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isNotEmpty) {
      final photos = await albums.first.getAssetListRange(start: 0, end: 100);

      _assets.addAll(photos);
    }

    setState(() => _loading = false);
  }

  void _toggleSelect(AssetEntity asset) {
    setState(() {
      if (_selected.contains(asset)) {
        _selected.remove(asset);
      } else {
        if (!widget.allowMultiple) {
          _selected.clear();
        }

        if (_selected.length < widget.maxSelection) {
          _selected.add(asset);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111111) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Row(
                  children: [
                    const Text(
                      'Photos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_selected.length}/${widget.maxSelection}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _selected.isEmpty
                          ? null
                          : () => widget.onDone(_selected),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _assets.isEmpty
                    ? const Center(child: Text('No photos found'))
                    : GridView.builder(
                        controller: controller,
                        padding: const EdgeInsets.all(12),
                        itemCount: _assets.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemBuilder: (context, index) {
                          final asset = _assets[index];
                          final selected = _selected.contains(asset);
                          final selectedIndex = _selected.indexOf(asset) + 1;

                          return GestureDetector(
                            onTap: () => _toggleSelect(asset),
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 180),
                              scale: selected ? 0.85 : 1,
                              curve: Curves.easeOutBack,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: AssetThumbnail(asset: asset),
                                  ),

                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: selected
                                          ? Colors.black.withOpacity(0.22)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selected
                                            ? Colors.deepPurpleAccent
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: selected ? 26 : 24,
                                      height: selected ? 26 : 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected
                                            ? Colors.black
                                            : Colors.white.withOpacity(0.75),
                                      ),
                                      child: selected
                                          ? Center(
                                              child: Text(
                                                '$selectedIndex',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;

  const AssetThumbnail({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(300, 300)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(color: Colors.black12);
        }

        return Image.memory(snapshot.data!, fit: BoxFit.cover);
      },
    );
  }
}
