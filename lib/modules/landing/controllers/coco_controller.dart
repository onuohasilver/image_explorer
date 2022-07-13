import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_explorer/services/coco_service/coco_service_impl.dart';

class CocoController extends ChangeNotifier {
  CocoController();

  final CocoServiceImpl _cocoService = CocoServiceImpl();
  final List<String> _categories = [];

  List<String> get categories => _categories;

  Future getCategories() async {
    log("get categories logger");
    try {
      Map result = await _cocoService.getCategories();
    } catch (e) {
      //TODO: ADD SNACKBAR
      log('An error');
    }
  }
}
