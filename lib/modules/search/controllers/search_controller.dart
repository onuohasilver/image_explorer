import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/models/models.dart';

class SearchController extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  Set<String> results = {};
  bool isIconCollapsed = false;
  String? searchText;

  collapseIcons() {
    isIconCollapsed = !isIconCollapsed;
    notifyListeners();
  }

  void onSearchInputChanged(String value, List<CategoryModel> categories) {
    log("Value: $value,Length ${value.length}");
    if (value.replaceAll("\u200b", "").isEmpty && results.isNotEmpty) {
      log("Backspace");
      deleteChip();
    }
    if (_checkForTerminatingCharacter(value)) {
      log('Terminating Space Found');
      searchCategories(value, categories);
      _resetTextEditingController();
      log(textEditingController.text);
    }

    searchText = value;
    log("${searchText?.length}");

    notifyListeners();
  }

  void updateSearchResults(String value, List<CategoryModel> categories) {
    searchCategories(value, categories);
    _resetTextEditingController();
  }

  /*
  Delete Chip widget
  */

  void deleteChip() {
    log("Deleting Chip");
    results.remove(results.last);
  }

  void deleteChipAtIndex(int index) {
    log("deleting chip by index");
    results.remove(results.elementAt(index));
    _resetTextEditingController();
    notifyListeners();
  }

  void deleteChipByValue(String value) {
    log("deleting chip by index");
    results.remove(value);
    _resetTextEditingController();
    notifyListeners();
  }

  /*
  Trigger when the user presses the 
  */
  bool _checkForTerminatingCharacter(value) {
    return value.endsWith(' ');
  }

  /*
  Reset the Text Editing to respond to empty backspace presses 
  */
  void _resetTextEditingController() {
    log('Text Editing Controller Reset');

    textEditingController =
        TextEditingController(text: _generatePlaceHolders());

    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));

    notifyListeners();
  }

  /*
  Search Categories
  */
  searchCategories(String value, List<CategoryModel> categories) {
    log("Searching for $value");
    List<CategoryModel> catToWatch = [...categories];
    catToWatch.removeWhere((element) => results.contains(element.category));

    String searchResult = catToWatch.firstWhere((element) {
      // log(element);
      return element.category
          .trim()
          .toLowerCase()
          .startsWith(value.replaceAll("\u200b", "").trim().toLowerCase());
    }, orElse: (() => CategoryModel('Null', 'Null'))).category;

    log(searchResult);
    if (searchResult != "Null") addToSearchResults(searchResult.trim());
    notifyListeners();
    if (results.length > 4) isIconCollapsed = true;
    if (results.length < 4) isIconCollapsed = false;
    log(results.toString());
  }

  void addToSearchResults(String value) {
    results.add(value);
  }

  /*
  Generate Placeholders
  */
  String _generatePlaceHolders() {
    log(results.toString());
    List<String> listCount = List.generate(results.length, (index) => "\u200b");

    return listCount.fold<String>(
        "", (previousValue, element) => previousValue + element);
  }

  bool checkIfPresent(String value) {
    return results.contains(value);
  }
}
