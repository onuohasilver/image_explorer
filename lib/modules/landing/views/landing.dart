import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    SearchController controller = Provider.of<SearchController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
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
            Consumer<SearchController>(builder: (context, __, _) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // contentPadding: const EdgeInsets.only(left: 10),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                ),
                child: Wrap(
                  spacing: 4,
                  children: [
                    ...List.generate(
                        controller.results.length,
                        (index) => InputChip(
                              key: ObjectKey(
                                  controller.results.elementAt(index)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                      color: Color(0xFFCCCCCC))),
                              label: Text(controller.results.elementAt(index)),
                              onDeleted: () => log('message'),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            )),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 300,
                            height: 20,
                            child: TextField(
                              controller: controller.textEditingController,

                              onChanged: (_) => {
                                controller.onSearchInputChanged(_),
                              },
                              // onSubmitted: (_) =>
                              //     controller.searchCategories(_),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

List<String> mocker = ["AB", "CB", "DB", "EB"];
