import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Provide a Media Query Space using a Sized Box in the horizontal direction

class XSpace extends StatelessWidget {
  final num value;
  const XSpace(
    this.value, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: value != 0, child: SizedBox(width: value.w));
  }
}

///Provide a Media Query Space using a Sized Box in the vertical direction

class YSpace extends StatelessWidget {
  final num value;
  const YSpace(
    this.value, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(visible: value != 0, child: SizedBox(height: value.h));
  }
}
