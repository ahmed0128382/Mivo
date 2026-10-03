import 'dart:io';

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final String? url;

  ImageView({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: PhotoView(
              imageProvider:
                  CachedNetworkImageProvider(
                url ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageFileView extends StatelessWidget {
  final File? Files;

  ImageFileView({
    this.Files,
  });

  @override
  Widget build(BuildContext context) {
    if (Files == null) {
      return const SizedBox.shrink();
    }

    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),

          // ==================================================
          // PREVIEW HEADER
          // ==================================================

          SizedBox(
            width: SizeConfig.screenWidth,
            height: 60,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // LOCAL FILE PREVIEW
          // ==================================================

          Expanded(
            child: PhotoView(
              imageProvider: FileImage(
                Files!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageView2 extends StatelessWidget {
  final String? url;

  ImageView2({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),

          SizedBox(
            width: SizeConfig.screenWidth,
            height: 60,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: PhotoView(
              imageProvider:
                  CachedNetworkImageProvider(
                url ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}