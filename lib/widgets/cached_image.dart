import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.imageUrl, this.radius = 0});
  final String? imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageUrl ?? '',
        errorWidget: (context, url, error) => Container(
          color: Colors.red,
        ),
        placeholder: (context, url) => Container(
          color: Colors.grey,
        ),
      ),
    );
  }
}
