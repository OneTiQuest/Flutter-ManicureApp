import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/FavoriteData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'models/Favorite.dart';
import 'models/db.dart';

class FavoriteView extends StatelessWidget {
  final Favorite favorite;

  FavoriteView(this.favorite);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await DB.delete(Favorite.table, favorite);
        context.read<FavoriteData>().changeData(Favorite.getFavorites());
        Fluttertoast.showToast(
          msg: "Маникюр удален из избранного",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        padding: const EdgeInsets.all(32),
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.blueGrey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.file(
            File(favorite.image),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
