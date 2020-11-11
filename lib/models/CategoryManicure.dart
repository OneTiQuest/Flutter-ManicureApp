import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/model.dart';

import 'db.dart';

class CategoryManicure extends Model {
  static String table = 'categories';

  final int id;
  final String name;
  final String color;
  final String design;

  CategoryManicure(
      {@required this.id,
      @required this.name,
      @required this.color,
      @required this.design});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'name': name, 'color': color, 'design': design};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static CategoryManicure fromMap(Map<String, dynamic> map) {
    return CategoryManicure(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      design: map['design'].toString(),
    );
  }

  static String getDesign(String num) {
    List<String> listDesign = [
      'Не задан',
      'Втирка',
      'Кошачий глаз',
      'Геометрия',
      'Градиент',
      'Флора',
      'Фауна',
      'Стразы',
      'Френч',
      'Разное'
    ];

    return listDesign[int.parse(num)];
  }

  static Future<CategoryManicure> getCategoryById(id) async {
    List<Map<String, dynamic>> res = await DB.query(CategoryManicure.table);
    Map<String, dynamic> elem =
        res.singleWhere((element) => element["id"] == id);
    CategoryManicure category = CategoryManicure.fromMap(elem);
    return category;
  }

  static Future<List<CategoryManicure>> getCategories() async {
    List<Map<String, dynamic>> res = await DB.query(CategoryManicure.table);
    List<CategoryManicure> list = res.isNotEmpty
        ? res.map((c) => CategoryManicure.fromMap(c)).toList()
        : [];
    list.sort((a, b) => a.name.compareTo(b.name));
    return list.isNotEmpty ? list : null;
  }
}
