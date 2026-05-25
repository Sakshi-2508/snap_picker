import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SnapPicker {
  static Future<void> show(
    BuildContext context, {
    bool allowMultiple = false,
    int maxSelection = 10,
    required ValueChanged<List<XFile>> onImagesSelected,
  }) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SnapPickerSheet(
          allowMultiple: allowMultiple,
          maxSelection: maxSelection,
          onImagesSelected: onImagesSelected,
        );
      },
    );
  }
}

class _SnapPickerSheet extends StatefulWidget {
  final bool allowMultiple;
  final int maxSelection;
  final ValueChanged<List<XFile>> onImagesSelected;

  const _SnapPickerSheet({
    required this.allowMultiple,
    required this.maxSelection,
    required this.onImagesSelected,
  });

  @override
  State<_SnapPickerSheet> createState() => _SnapPickerSheetState();
}

class _SnapPickerSheetState extends State<_SnapPickerSheet> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    if (widget.allowMultiple) {
      final images = await _picker.pickMultiImage();

      if (images.isNotEmpty) {
        final limitedImages = images.take(widget.maxSelection).toList();
        widget.onImagesSelected(limitedImages);
        if (mounted) Navigator.pop(context);
      }
    } else {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        widget.onImagesSelected([image]);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      widget.onImagesSelected([image]);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Snap Picker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose images beautifully',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: _OptionCard(
                    icon: Icons.photo_library_rounded,
                    title: 'Gallery',
                    subtitle: widget.allowMultiple
                        ? 'Pick multiple images'
                        : 'Pick one image',
                    onTap: _pickFromGallery,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _OptionCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'Camera',
                    subtitle: 'Capture new image',
                    onTap: _pickFromCamera,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1D1D1D) : const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isDark ? Colors.white10 : Colors.black,
              child: Icon(
                icon,
                color: isDark ? Colors.white : Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
