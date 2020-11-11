import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Manicure.dart';

class ManicureData with ChangeNotifier {
  int categoryId;
  Future<List<Manicure>> _manicure;

  ManicureData(this.categoryId) {
    _manicure = Manicure.getManicureById(categoryId);
  }

  get getManicures => _manicure;

  void changeData(newManicures) {
    _manicure = newManicures;
    notifyListeners();
  }
}
