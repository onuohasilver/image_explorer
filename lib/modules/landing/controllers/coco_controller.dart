import 'dart:developer';

import 'package:collection/src/comparators.dart';
import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/controllers/coco_states.dart';
import 'package:image_explorer/modules/landing/models/models.dart';
import 'package:image_explorer/modules/landing/models/result_model.dart';
import 'package:image_explorer/services/coco_service/coco_service_impl.dart';

class CocoController extends ChangeNotifier {
  CocoController();

  final CocoServiceImpl _cocoService = CocoServiceImpl();
  final List<CategoryModel> _categories = [];

  final List<ResultModel> _queryResult = [];

  List<CategoryModel> get categories => _categories;

  List<ResultModel> get queryResults => _queryResult;

  CocoState state = CocoState.idle;

  Future query(Set<String> searchResult) async {
    List<String> categoryIds = [];
    for (String keyword in searchResult) {
      categoryIds.add(categories
          .firstWhere((element) =>
              element.category.toLowerCase().trim() ==
              keyword.toLowerCase().trim())
          .id);
    }

    _queryResult.clear();
    log('Query Started');
    state = CocoState.loading;
    notifyListeners();
    try {
      List imagesByCategory = await _cocoService.getImagesByCats(categoryIds);
      List imageCaptions =
          await _cocoService.getImageCaptions(imagesByCategory);
      List imageSegmentations =
          await _cocoService.getImageSegmentations(imagesByCategory);
      List imageResults = await _cocoService.getImageResults(imagesByCategory);

      for (var image in imagesByCategory) {
        List segments = imageSegmentations
            .where((element) => element['image_id'] == image)
            .toList();

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

        _queryResult.add(
          ResultModel(
              segmentation: segmentData,
              captions: imageCaptions
                  .where((element) => element['image_id'] == image)
                  .toList(),
              imageID: image,
              imageUrl: imageResults.firstWhere(
                  (element) => element['id'] == image,
                  orElse: () => {'coco_url': ''})['coco_url']),
        );
      }
      // log(_queryResult.first.toString());
      state = CocoState.idle;
      notifyListeners();
    } catch (e) {
      state = CocoState.error;
      log(e.toString());
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
