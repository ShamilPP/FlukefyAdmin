import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  const ImageSelector({Key? key}) : super(key: key);

  static ValueNotifier<List<String>> imagesNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ValueListenableBuilder<List<String>>(
                valueListenable: imagesNotifier,
                builder: (ctx, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...value.asMap().entries.map((entry) {
                        // Image Viewer
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  image: DecorationImage(
                                      image: FileImage(
                                        File(entry.value),
                                      ),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Material(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      splashColor: Colors.white,
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close_sharp,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        List<String> images = imagesNotifier.value;
                                        images.remove(images[entry.key]);
                                        imagesNotifier.value = [...images];
                                      },
                                    ),
                                  ),
                                ),
                              )),
                        );
                      }),
                      // Add Image button
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          splashColor: Colors.black,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration:
                                BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(imagesNotifier.value.isEmpty ? 'Select image' : 'Add image')),
                          ),
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              List<String> images = imagesNotifier.value;
                              images.add(image.path);
                              imagesNotifier.value = [...images];
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ValueListenableBuilder<List<String>>(
                valueListenable: imagesNotifier,
                builder: (ctx, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: value.asMap().entries.map((entry) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(value.length - 1 == entry.key ? 0.9 : 0.4),
                        ),
                      );
                    }).toList(),
                  );
                }),
          )
        ],
      ),
    );
  }
}
