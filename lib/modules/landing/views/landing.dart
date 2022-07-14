import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_explorer/modules/landing/controllers/coco_controller.dart';
import 'package:image_explorer/modules/landing/views/widgets/coco_icons_builder.dart';
import 'package:image_explorer/modules/landing/views/widgets/search_builder.dart';
import 'package:image_explorer/modules/search/controllers/search_controller.dart';
import 'package:image_explorer/shared_components/shared_components.dart';
import 'package:provider/provider.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    CocoController cocoController = Provider.of<CocoController>(context);
    SearchController searchController = Provider.of<SearchController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: FutureBuilder(
          future: cocoController.getCategories(),
          builder: (context, _) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText("Coco Explorer",
                      size: 20, weight: FontWeight.bold),
                  const YSpace(20),
                  const CustomText(
                      'COCO 2017 train/val browser (123,287 images, 886,284 instances). Crowd labels not shown.',
                      size: 14,
                      height: 1.3,
                      color: Colors.grey),
                  const YSpace(10),
                  const CocoIconsBuilder(),
                  const YSpace(10),
                  const SearchBuilder(),
                  const YSpace(10),
                  TextButton(
                      onPressed: () => cocoController.getCategories(),
                      child: const Text("Search")),
                ],
              ),
            );
          }),
    );
  }
}
