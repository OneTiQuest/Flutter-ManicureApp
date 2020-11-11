import 'package:flutter/material.dart';
import 'package:flutter_app/FavoriteView.dart';
import 'package:flutter_app/data/FavoriteData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/Favorite.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<FavoriteData>().getFavorites,
      builder: (BuildContext context, AsyncSnapshot<List<Favorite>> snap) {
        if (snap.hasData && snap.data.isNotEmpty) {
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (context, index) {
              Favorite item = snap.data[index];
              return FavoriteView(item);
            },
          );
        } else {
          return Container(
            child: Center(
              child: Text(
                "Нет избранного",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
