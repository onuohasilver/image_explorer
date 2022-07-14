import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_explorer/services/coco_service/coco_service_impl.dart';

class CocoController extends ChangeNotifier {
  CocoController();

  final CocoServiceImpl _cocoService = CocoServiceImpl();
  final List<String> _categories = [];
  final List<String> _categoryID = [];

  List<String> get categories => _categories;
  List<String> get categoryID => _categoryID;

  Future getCategories() async {
    log("get categories logger");
    if (_categories.isEmpty) {
      try {
        Map result = await _cocoService.getCategories();
        // String catNames = result['catToId'];
        // print(catNames);

        List<String> catNames = result['catToId']
            .replaceAll('[', '')
            .replaceAll(']', '')
            .replaceAll('}', '')
            .replaceAll('{', '')
            .replaceAll(';', '')
            .split(',');
        catNames.sort(compareNatural);
        for (var element in catNames) {
          _categories.add(element.split(":").first.trim());
          _categoryID.add(element.split(":").last.trim());
        }
        // categoryID.sort(compareNatural);
        log(categories.toString());
        log(categoryID.toString());
        notifyListeners();
      } catch (e) {
        //TODO: ADD SNACKBAR
        print(e);
        log('An error');
      }
    }
  }
}
