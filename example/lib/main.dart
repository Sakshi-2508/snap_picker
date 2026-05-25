import 'package:flutter/material.dart';
import 'package:snap_picker/snap_picker.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const SnapPickerExample());
}

class SnapPickerExample extends StatelessWidget {
  const SnapPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snap Picker Example',
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<XFile> selectedImages = [];

  bool isUploading = false;
  double uploadProgress = 0;
  bool uploadComplete = false;

  void openPicker() {
    SnapPicker.show(
      context,
      allowMultiple: true,
      maxSelection: 5,
      onImagesSelected: (images) {
        setState(() {
          selectedImages.addAll(images);

          uploadProgress = 0;
          uploadComplete = false;
          isUploading = false;
        });
      },
    );
  }

  void removeImage(XFile image) {
    setState(() {
      selectedImages.remove(image);

      uploadProgress = 0;
      uploadComplete = false;
      isUploading = false;
    });
  }

  Future<void> startUpload() async {
    setState(() {
      isUploading = true;
      uploadComplete = false;
      uploadProgress = 0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        uploadProgress = i / 10;
      });
    }

    setState(() {
      isUploading = false;
      uploadComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Snap Picker',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Beautiful image selection made simple.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 28),

              if (selectedImages.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library_rounded,
                          size: 42,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        'No images selected',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Tap the button below to start picking beautiful images.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: openPicker,
                  icon: const Icon(Icons.add_photo_alternate_rounded),
                  label: const Text('Open Snap Picker'),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                '${selectedImages.length} images selected',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              SnapPickerPreview(images: selectedImages, onRemove: removeImage),

              const SizedBox(height: 24),

              if (selectedImages.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.cloud_upload_rounded),
                          SizedBox(width: 10),
                          Text(
                            'Upload Progress',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      LinearProgressIndicator(
                        value: uploadProgress,
                        borderRadius: BorderRadius.circular(30),
                        minHeight: 10,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '${selectedImages.length} images ready to upload',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isUploading ? null : startUpload,
                          child: Text(
                            uploadComplete
                                ? 'Upload Complete'
                                : isUploading
                                ? 'Uploading...'
                                : 'Upload Images',
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (uploadComplete)
                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Images uploaded successfully',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
