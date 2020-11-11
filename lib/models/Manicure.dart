import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/model.dart';

import 'db.dart';

class Manicure extends Model {
  static String table = 'manicure';

  final int id;
  final String name;
  final String image;
  final int categoryId;

  Manicure(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.categoryId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'image': image,
      'categoryId': categoryId
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Manicure fromMap(Map<String, dynamic> map) {
    return Manicure(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      categoryId: map['categoryId'],
    );
  }

  static Future<List<Manicure>> getManicureById(categoryId) async {
    List<Map<String, dynamic>> res = await DB.query(Manicure.table);
    List<Map<String, dynamic>> items =
        res.where((element) => element["categoryId"] == categoryId).toList();
    List<Manicure> manicure = items.map((e) => Manicure.fromMap(e)).toList();
    return manicure.isNotEmpty ? manicure : null;
  }
}
