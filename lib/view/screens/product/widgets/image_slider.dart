import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../image_viewer/image_viewer_screen.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final String imageHeroTag;
  final double imageHeight;

  const ImageSlider({required this.images, Key? key, required this.imageHeroTag, required this.imageHeight}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentIndex = 0;
  CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          options: CarouselOptions(
            height: widget.imageHeight,
            viewportFraction: 1,
            aspectRatio: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemCount: widget.images.length,
          itemBuilder: (ctx, index, value) {
            var heroTag = index == 0 ? widget.imageHeroTag : '$value';
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ImageViewer(
                              image: widget.images[index],
                              tag: heroTag,
                            )));
              },
              child: Hero(
                tag: heroTag,
                child: Image.network(
                  widget.images[index],
                  height: widget.imageHeight,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(
                        child: SpinKitPulse(color: Colors.black, size: 30),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        // Number of images
        Positioned.fill(
          bottom: 30,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => controller.animateToPage(entry.key),
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(currentIndex == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
