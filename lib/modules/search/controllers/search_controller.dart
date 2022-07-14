import 'dart:developer';

import 'package:flutter/material.dart';

class SearchController extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  Set<String> results = {};
  String? searchText;

  void onSearchInputChanged(String value, List<String> categories) {
    log("Value: $value,Length ${value.length}");
    if (value.replaceAll("\u200b", "").isEmpty && results.isNotEmpty) {
      log("Backspace");
      deleteChip();
    }
    if (_checkForTerminatingCharacter(value)) {
      log('Terminating Space Found');
      searchCategories(value, categories);
      _resetTextEditingController(value);
      log(textEditingController.text);
    }

    searchText = value;
    log("${searchText?.length}");

    notifyListeners();
  }

  void updateSearchResults(String value, List<String> categories) {
    searchCategories(value, categories);
    _resetTextEditingController(value);
  }

  /*
  Delete Chip widget
  */

  void deleteChip() {
    log("Deleting Chip");
    results.remove(results.last);
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
  void _resetTextEditingController(value) {
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
  searchCategories(String value, List categories) {
    log("Searching for $value");
    List catToWatch = [...categories];
    catToWatch.removeWhere((element) => results.contains(element));
    String searchResult = categories.firstWhere((element) {
      // log(element);
      return element
          .trim()
          .toLowerCase()
          .startsWith(value.replaceAll("\u200b", "").trim().toLowerCase());
    }, orElse: (() => 'Null'));

    log(searchResult);
    if (searchResult != "Null") addToSearchResults(searchResult.trim());
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
}
