import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/controllers/coco_controller.dart';
import 'package:image_explorer/modules/search/controllers/search_controller.dart';
import 'package:provider/provider.dart';

class SearchBuilder extends StatelessWidget {
  const SearchBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchController controller = Provider.of<SearchController>(context);
    CocoController cocoController = Provider.of<CocoController>(context);
    return Consumer<SearchController>(builder: (context, __, _) {
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
          runSpacing: 10,
          children: [
            ...List.generate(
                controller.results.length,
                (index) => InputChip(
                      key: ObjectKey(controller.results.elementAt(index)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Color(0xFFCCCCCC))),
                      label: Text(controller.results.elementAt(index)),
                      onDeleted: () => log('message'),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 60,
                    height: 20,
                    child: TextField(
                      controller: controller.textEditingController,

                      onChanged: (_) => {
                        controller.onSearchInputChanged(
                            _, cocoController.categories),
                      },
                      // onSubmitted: (_) =>
                      //     controller.searchCategories(_),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

List<String> mocker = ["AB", "CB", "DB", "EB"];
