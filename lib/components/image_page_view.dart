import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sale_garage_platform/screens/images_full_screen.dart';
import 'package:photo_view/photo_view.dart';

class ImagePageView extends StatelessWidget {
  final List<CachedNetworkImageProvider> images;

  const ImagePageView({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagesFullScreen(
                      images: images,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: PhotoView(
                imageProvider: images[index],
                backgroundDecoration: BoxDecoration(color: Colors.white12),
                loadingBuilder: (context, loadingProgress) => Center(
                    child: CircularProgressIndicator(
                )),
              ));
        },
        itemCount: images.length,
      ),
    );
  }
}
