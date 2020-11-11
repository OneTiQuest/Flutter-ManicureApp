import 'package:flutter/material.dart';
import 'package:flutter_app/CategoryView.dart';
import 'package:flutter_app/FavoritePage.dart';
import 'package:flutter_app/data/CategoryData.dart';
import 'package:flutter_app/models/CategoryManicure.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'data/FavoriteData.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Категории",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: FutureBuilder<List<CategoryManicure>>(
            future: context.watch<CategoryData>().getCategories,
            builder: (BuildContext context,
                AsyncSnapshot<List<CategoryManicure>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    CategoryManicure item = snapshot.data[index];
                    return Column(
                      children: [
                        CategoryView(category: item),
                        index + 1 != snapshot.data.length
                            ? Divider(
                                indent: 36,
                                endIndent: 36,
                              )
                            : Text(""),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    "Нет категорий",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
            ),
            onPressed: () => Navigator.pushNamed(context, '/create-cat'),
            elevation: 5,
            tooltip: "Добавить категорию",
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Избранное",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: ChangeNotifierProvider(
            create: (context) => FavoriteData(),
            child: FavoritePage(),
          ),
        ),
      ],
    );
  }
}
