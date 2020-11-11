import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/CategoryView.dart';
import 'package:flutter_app/models/Manicure.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'data/ManicureData.dart';
import 'models/Favorite.dart';
import 'models/db.dart';

class ManicureView extends StatelessWidget {
  final Manicure manicure;
  final int categoryId;
  final String color;

  ManicureView(
      {@required this.manicure,
      @required this.categoryId,
      @required this.color});

  Future<String> _getPathImage() async {
    final Directory appPath = await getApplicationDocumentsDirectory();
    String pathImage = appPath.path + "/" + manicure.image;
    return pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _getPathImage().then((path) {
          File file = File(path);
          file.deleteSync();
          File file2 = File(path);
          DB.delete(Manicure.table, manicure);

          //Удаление избранного
          Future<List<Map<String, dynamic>>> listFavorite =
              DB.query(Favorite.table);

          listFavorite.then((list) {
            list.forEach((element) {
              if (element["image"] == path) {
                Favorite favorite = Favorite.fromMap(element);
                DB.delete(Favorite.table, favorite);
                return;
              }
            });
          });

          context
              .read<ManicureData>()
              .changeData(Manicure.getManicureById(categoryId));
        });

        Fluttertoast.showToast(
          msg: "Маникюр удалён",
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
          color: CategoryView.fromHex(color),
        ),
        child: FutureBuilder(
          future: _getPathImage(),
          builder: (BuildContext context, AsyncSnapshot mc) {
            if (mc.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      height: 480,
                      padding: const EdgeInsets.all(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Image.file(
                          File(mc.data),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ButtonTheme(
                      buttonColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: RaisedButton(
                        onPressed: () async {
                          List<Map<String, dynamic>> listFavorite =
                              await DB.query(Favorite.table);
                          bool error = false;
                          listFavorite.forEach((element) {
                            if (element["image"] == mc.data) error = true;
                          });

                          if (error == false) {
                            DB.insert(
                              Favorite.table,
                              Favorite(name: "favorite", image: mc.data),
                            );
                            Fluttertoast.showToast(
                              msg: "Маникюр добавлен в избранное",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Маникюр уже добавлен в избранное",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              gravity: ToastGravity.SNACKBAR,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.whatshot_outlined,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.white));
          },
        ),
      ),
    );
  }
}
