import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/ManicureView.dart';
import 'package:flutter_app/RandCategoryPhoto.dart';
import 'package:flutter_app/data/ManicureData.dart';
import 'package:flutter_app/models/CategoryManicure.dart';
import 'package:flutter_app/models/Manicure.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/db.dart';

class CategoryPage extends StatefulWidget {
  int categoryId;

  CategoryPage(this.categoryId);

  @override
  State<StatefulWidget> createState() => _CategoryPage(categoryId);
}

class _CategoryPage extends State<CategoryPage> {
  int categoryId;

  _CategoryPage(this.categoryId);

  final imagePicker = ImagePicker();
  File _image;

  getImage() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await _saveImage(_image);
    }
  }

  void _saveImage(File image) async {
    final Directory appPath = await getApplicationDocumentsDirectory();
    String imagePath = "image_" + image.hashCode.toString();
    await DB.insert(Manicure.table,
        Manicure(name: "image", image: imagePath, categoryId: categoryId));

    File resultFile = await image.copy(appPath.path + "/" + imagePath);
  }

  //Удаляет весь маникюр ----- Вызвать в build
  void _deleteManicures() async {
    final Directory appPath = await getApplicationDocumentsDirectory();
    List m = await DB.query(Manicure.table);
    List<Manicure> list = m.map((e) {
      print(e);
      return Manicure.fromMap(e);
    }).toList();

    list.forEach((element) {
      DB.delete(Manicure.table, element);
      File file = File(appPath.path + "/" + element.image);
      file.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Future<CategoryManicure> category =
        CategoryManicure.getCategoryById(categoryId);

    return ChangeNotifierProvider(
      create: (context) => ManicureData(categoryId),
      child: FutureBuilder(
        future: category,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  snapshot.data.name,
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  () {
                    return FutureBuilder(
                      future: context.watch<ManicureData>().getManicures,
                      builder: (BuildContext context, AsyncSnapshot manicures) {
                        if (manicures.data != null && manicures.hasData) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RandCategoryPhoto(
                                        categoryId: categoryId))),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return Text("");
                        }
                      },
                    );
                  }(),
                ],
              ),
              body: FutureBuilder(
                future: context.watch<ManicureData>().getManicures,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Manicure>> snap) {
                  if (snap.hasData) {
                    return ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        Manicure item = snap.data[index];
                        return ManicureView(
                          manicure: item,
                          categoryId: categoryId,
                          color: snapshot.data.color,
                        );
                      },
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text(
                          "Нет изображений",
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
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                ),
                onPressed: () async => {
                  await getImage(),
                  context
                      .read<ManicureData>()
                      .changeData(Manicure.getManicureById(categoryId))
                },
                elevation: 5,
                tooltip: "Добавить маникюр",
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
