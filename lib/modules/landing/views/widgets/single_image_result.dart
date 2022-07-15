import 'dart:async';
import 'dart:math';

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
    return FutureBuilder<Size>(
        key: Key(model.imageUrl),
        future: _calculateImageDimension(model.imageUrl),
        builder: (context, snapshot) {
          if (snapshot.hasData & (snapshot.data != null)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CustomPaint(
                foregroundPainter:
                    SegmentPainter(model.segmentation, snapshot.data!),
                child: CachedNetworkImage(
                  imageUrl: model.imageUrl,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class SegmentPainter extends CustomPainter {
  SegmentPainter(this.segments, this.imageSize);
  final List segments;
  final Size imageSize;
  final painter = Paint()..style = PaintingStyle.fill;
  Path path = Path();
  Path linePath = Path();
  @override
  void paint(Canvas canvas, Size size) {
    for (var j = 0; j < segments.length; j++) {
      log(segments.length);
      var r = (Random().nextDouble() * 255).floor();
      var g = (Random().nextDouble() * 255).floor();
      var b = (Random().nextDouble() * 255).floor();

      painter.color = Color.fromRGBO(r, g, b, 0.1);

      var poly = segments[j];

      try {
        final borderPainter = Paint()
          ..strokeWidth = 1
          ..color = Colors.black
          ..style = PaintingStyle.stroke;

        path.moveTo(
          getXdimension(poly[0], size, imageSize),
          getYdimension(poly[1], size, imageSize),
        );
        linePath.moveTo(
          getXdimension(poly[0], size, imageSize),
          getYdimension(poly[1], size, imageSize),
        );

        for (int m = 0; m < poly.length - 4; m += 2) {
          path.lineTo(
            getXdimension(poly[m + 2], size, imageSize),
            getYdimension(poly[m + 3], size, imageSize),
          );
          linePath.lineTo(
            getXdimension(poly[m + 2], size, imageSize),
            getYdimension(poly[m + 3], size, imageSize),
          );
        }

        path.moveTo(
          getXdimension(poly[0], size, imageSize),
          getYdimension(poly[1], size, imageSize),
        );
        linePath.moveTo(
          getXdimension(poly[0], size, imageSize),
          getYdimension(poly[1], size, imageSize),
        );
        path.close();
        linePath.close();
        canvas.drawPath(path, painter);

        canvas.drawPath(linePath, borderPainter);
      } catch (err) {}
    }

    canvas.drawPath(path, painter);
  }

  double getXdimension(double x, Size newSize, Size oldSize) {
    return x * newSize.width / oldSize.width;
  }

  double getYdimension(double y, Size newSize, Size oldSize) {
    return y * newSize.height / oldSize.height;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Future<Size> _calculateImageDimension(String imageUrl) {
  Completer<Size> completer = Completer();
  Image image = Image(image: CachedNetworkImageProvider(imageUrl));
  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo image, bool synchronousCall) {
      var myImage = image.image;
      Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
      completer.complete(size);
    }),
  );
  return completer.future;
}

// Javascript implementation of vals
// function renderSegms(ctx, img, data) {
//   var cats = Object.keys(data);
//   for (var i = 0; i < cats.length; i++) {
//     // set color for each object
//     var segms = data[cats[i]];
//     for (var j = 0; j < segms.length; j++) {
//       var r = Math.floor(Math.random() * 255);
//       var g = Math.floor(Math.random() * 255);
//       var b = Math.floor(Math.random() * 255);
//       ctx.fillStyle = 'rgba(' + r + ',' + g + ',' + b + ',0.7)';
//       var polys = JSON.parse(segms[j]['segmentation']);
//       // loop over all polygons
//       for (var k = 0; k < polys.length; k++) {
//         var poly = polys[k];
//         ctx.moveTo(poly[0], poly[1]);
//         for (m = 0; m < poly.length - 2; m += 2) {
//           // let's draw!!!!
//           ctx.lineTo(poly[m + 2], poly[m + 3]);
//         }
//         ctx.lineTo(poly[0], poly[1]);
//         ctx.lineWidth = 3;
//         ctx.closePath();
//         ctx.fill();
//         ctx.strokeStyle = 'black';
//         ctx.stroke();
//       }
//     }
//   }
// }
