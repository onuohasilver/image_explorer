import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/models/result_model.dart';

class SingleImageResult extends StatelessWidget {
  const SingleImageResult({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ResultModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CachedNetworkImage(
        imageUrl: model.imageUrl,
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
