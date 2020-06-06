import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedImageProvider({String mediaUrl, double height, double width}) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

roundedCachedImageProvider({String mediaUrl, double height, double width}) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => Padding(
      padding: EdgeInsets.all(20),
      child: Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}
