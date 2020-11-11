import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/Favorite.dart';

class FavoriteData with ChangeNotifier {
  Future<List<Favorite>> _favorites = Favorite.getFavorites();

  get getFavorites => _favorites;

  void changeData(newFavorites) {
    _favorites = newFavorites;
    notifyListeners();
  }
}
