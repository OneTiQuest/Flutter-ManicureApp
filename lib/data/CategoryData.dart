import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/CategoryManicure.dart';

class CategoryData with ChangeNotifier {
  Future<List<CategoryManicure>> _categories = CategoryManicure.getCategories();

  get getCategories => _categories;

  void changeData(newCategories) {
    _categories = newCategories;
    notifyListeners();
  }
}
