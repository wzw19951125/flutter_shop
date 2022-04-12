import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    fit: BoxFit.cover,
    width: width,
    placeholder: (context, url) {
      return Container(
        color: Colors.grey,
      );
    },
    errorWidget: (context, url, error) {
      return Icon(Icons.error);
    },
  );
}
