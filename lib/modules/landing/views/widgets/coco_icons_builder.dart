import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_explorer/core/core.dart';
import 'package:image_explorer/modules/landing/controllers/coco_controller.dart';
import 'package:image_explorer/modules/search/controllers/search_controller.dart';
import 'package:image_explorer/shared_components/shared_components.dart';
import 'package:provider/provider.dart';

class CocoIconsBuilder extends StatelessWidget {
  const CocoIconsBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CocoController cocoController = Provider.of<CocoController>(context);
    SearchController searchController = Provider.of<SearchController>(context);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: (searchController.isIconCollapsed) ? 130.h : 450.h,
          child: SingleChildScrollView(
            child: Wrap(
              clipBehavior: Clip.hardEdge,
              runSpacing: 12,
              spacing: 12,
              children: List.generate(
                cocoController.categories.length,
                (index) => GestureDetector(
                  onTap: () => {
                    if (!searchController.checkIfPresent(
                        cocoController.categories[index].category))
                      {
                        searchController.updateSearchResults(
                            cocoController.categories[index].category,
                            cocoController.categories)
                      }
                    else
                      {
                        searchController.deleteChipByValue(
                            cocoController.categories[index].category)
                      }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: searchController.results.contains(
                                cocoController.categories[index].category)
                            ? Border.all(color: Colors.lime, width: 2)
                            : null),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${Api.cocoIcons}${cocoController.categories[index].id}.jpg",
                      width: 30.h,
                      height: 30.h,
                      placeholder: (context, url) => Container(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        TextButton.icon(
            onPressed: () {
              searchController.collapseIcons();
            },
            label: !searchController.isIconCollapsed
                ? const CustomText('Collapse Icons', size: 12)
                : const CustomText('Expand Icons', size: 12),
            icon: !searchController.isIconCollapsed
                ? const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.purple,
                  )
                : const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.purple,
                  ))
      ],
    );
  }
}
