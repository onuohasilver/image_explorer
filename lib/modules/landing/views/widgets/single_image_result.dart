import 'dart:developer';

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
      child: CustomPaint(
        foregroundPainter: SegmentPainter(model.segmentation),
        child: CachedNetworkImage(
          imageUrl: model.imageUrl,
          placeholder: (context, url) => Container(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

class SegmentPainter extends CustomPainter {
  SegmentPainter(this.segments);
  final List segments;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    var path = Path();

    List<List> segmentData = [];

    for (var data in segments) {
      List result = [];
      List rawData = data['segmentation']
          .replaceAll('[', '')
          .replaceAll(']]', '')
          .split(',');
      for (var element in rawData) {
        double? val = double.tryParse(element);
        if (val != null) result.add(val);
      }
      segmentData.add(result);
    }

    log(segmentData.toString());
    for (var segment in segmentData) {
      for (var i = 0; i < segment.length - 1; i++) {
        path.moveTo(segment[0], segment[1]);
        for (var m = 0; m < segment.length - 4; m += 2) {
          path.lineTo(segment[m + 2], segment[m + 3]);
        }
        path.lineTo(segment[0], segment[1]);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
