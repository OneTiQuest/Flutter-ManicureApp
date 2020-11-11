import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/model.dart';

import 'db.dart';

class Favorite extends Model {
  static String table = 'favorite';

  final int id;
  final String name;
  final String image;

  Favorite({@required this.id, @required this.name, @required this.image});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'image': image,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Favorite fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  static Future<Favorite> getCategoryById(id) async {
    List<Map<String, dynamic>> res = await DB.query(Favorite.table);
    Map<String, dynamic> elem =
        res.singleWhere((element) => element["id"] == id);
    Favorite favorite = Favorite.fromMap(elem);
    return favorite;
  }

  static Future<List<Favorite>> getFavorites() async {
    List<Map<String, dynamic>> favorites = await DB.query(Favorite.table);
    return favorites.map((e) => Favorite.fromMap(e)).toList();
  }
}
