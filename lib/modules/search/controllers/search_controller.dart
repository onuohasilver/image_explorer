import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_explorer/modules/landing/models/models.dart';

class SearchController extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();

  Set<String> results = {};
  bool isIconCollapsed = false;
  String? searchText;

  /*
  Manually control the height of the CocoIcons Builder
  :: Reduce the height when space is conceded to allow 
  :: better use of available screen
  */
  collapseIcons() {
    isIconCollapsed = !isIconCollapsed;
    notifyListeners();
  }

  /*
  Series of methods called when the search input has been updated
  via user interaction with the [textEditingController]
  */

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

  /*
  Update the values in the search results to add widget chips
  :: Also resets the [textEditingController] to include [backSpace]
  :: notifiiers for the newly added values
  */
  void updateSearchResults(String value, List<CategoryModel> categories) {
    searchCategories(value, categories);
    _resetTextEditingController();
  }

  /*
  Delete Chip widget
  :: Removes the last value in the result 
  :: This updates the UI by removing a value in the
  searchbuilder
  */

  void deleteChip() {
    log("Deleting Chip");
    results.remove(results.last);
  }

  /*
  Delete Chip At Index
  :: Removes a chip at the parsed index
  */

  void deleteChipAtIndex(int index) {
    log("deleting chip by index");
    results.remove(results.elementAt(index));
    _resetTextEditingController();
    notifyListeners();
  }
/*
  Delete Chip By value
  :: Removes a chip at the parsed index
  */

  void deleteChipByValue(String value) {
    log("deleting chip by index");
    results.remove(value);
    _resetTextEditingController();
    notifyListeners();
  }

  /*
  Trigger when the user presses the Space Character
  :: indicate end of Current Input interaction
  */
  bool _checkForTerminatingCharacter(value) {
    return value.endsWith(' ');
  }

  /*
  Reset the Text Editing to respond to empty backspace presses 
  :: Updates the textEditingController initial Text to contain invisible characters
  :: Updates the position of the textEditingController cursor
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
  }

  /*
  Programmatically update the [results] Set
  */
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

  /*
  Check if result contains a parsed value
  */

  bool checkIfPresent(String value) {
    return results.contains(value);
  }
}
