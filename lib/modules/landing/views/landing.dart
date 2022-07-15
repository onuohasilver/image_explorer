import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_explorer/modules/landing/controllers/coco_states.dart';
import 'package:image_explorer/modules/landing/views/widgets/single_image_result.dart';
import 'package:image_explorer/modules/modules.dart';
import 'package:image_explorer/shared_components/shared_components.dart';
import 'package:provider/provider.dart';

import '../controllers/coco_states.dart';

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
              child: SingleChildScrollView(
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
                    const YSpace(5),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple)),
                          onPressed: () async {
                            cocoController.query(searchController.results);
                          },
                          child: const Text("Search")),
                    ),
                    const YSpace(5),
                    if (cocoController.state == CocoState.loading)
                      const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 1.0, color: Colors.purple)),
                    if (cocoController.queryResults.isEmpty &&
                        (cocoController.state == CocoState.idle))
                      const Center(
                          child: CustomText('No results found', size: 12)),
                    if (cocoController.state == CocoState.error)
                      const Center(
                        child: CustomText(
                          'An error occured',
                          size: 15,
                        ),
                      ),
                    if (cocoController.queryResults.isNotEmpty)
                      SizedBox(
                        height: 400.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "${cocoController.queryResults.length} results found",
                              size: 12,
                              color: Colors.grey,
                            ),
                            const YSpace(12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: cocoController.queryResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return SingleImageResult(
                                      model:
                                          cocoController.queryResults[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
