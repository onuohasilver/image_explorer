import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/models/models.dart';
import 'package:image_explorer/services/coco_service/coco_service_impl.dart';

class CocoController extends ChangeNotifier {
  CocoController();

  final CocoServiceImpl _cocoService = CocoServiceImpl();
  final List<CategoryModel> _categories = [];
  final List<String> _imageResponse = [];
  

  List<CategoryModel> get categories => _categories;
  List<String> get imageResponse => _imageResponse;

  Future query(List<String> categoryIds) async {
    try {
      List imagesByCategory = await _cocoService.getImagesByCats(categoryIds);
      List imageCaptions =
          await _cocoService.getImageCaptions(imagesByCategory);
      List imageSegmentations =
          await _cocoService.getImageSegmentations(imagesByCategory);
      List imageResults = await _cocoService.getImageResults(imagesByCategory);
      print([
        imagesByCategory.length,
        imageCaptions.length,
        imageSegmentations.length,
        imageResults.length
      ]);
    } catch (e) {
      log('An error occured, try again');
    }
  }

  Future _paginateQuery() async {}

  Future getCategories() async {
    log("get categories logger");
    if (_categories.isEmpty) {
      try {
        Map result = await _cocoService.getCategories();

        List<String> catNames = result['catToId']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('}', '')
            .replaceAll('{', '')
            .replaceAll(';', '')
            .split(',');
        catNames.sort(compareNatural);
        for (var element in catNames) {
          _categories.add(CategoryModel.fromJson({
            'category': element.split(":").first.trim(),
            'id': element.split(":").last.trim()
          }));
        }

        notifyListeners();
      } catch (e) {
        //TODO: ADD SNACKBAR
        print(e);
        log('An error');
      }
    }
  }
}
