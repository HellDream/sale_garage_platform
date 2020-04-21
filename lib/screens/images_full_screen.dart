import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/components/back_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesFullScreen extends StatefulWidget {
  final List<CachedNetworkImageProvider> images;
  final int initialIndex;

  const ImagesFullScreen({Key key, this.images, this.initialIndex})
      : super(key: key);

  @override
  _ImagesFullScreenState createState() => _ImagesFullScreenState();
}

class _ImagesFullScreenState extends State<ImagesFullScreen> {
  int currentIndex;
  PageController pageController;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              loadingBuilder: (context, event) => CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
              itemCount: widget.images.length,
              scrollDirection: Axis.horizontal,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              pageController: pageController,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: widget.images[index],
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                );
              },
            ),
            Container(
              child: TopBackBtn(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
