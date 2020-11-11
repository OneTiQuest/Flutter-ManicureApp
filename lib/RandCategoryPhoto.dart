import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/CategoryView.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'models/CategoryManicure.dart';
import 'models/Manicure.dart';

class RandCategoryPhoto extends StatefulWidget {
  int categoryId;

  RandCategoryPhoto({@required this.categoryId});

  @override
  State<StatefulWidget> createState() =>
      _RandCategoryPhoto(categoryId: categoryId);
}

class _RandCategoryPhoto extends State<RandCategoryPhoto> {
  int categoryId;

  _RandCategoryPhoto({@required this.categoryId});

  Future<Map<String, dynamic>> _getRandImage() async {
    final List<Manicure> _manicure = await Manicure.getManicureById(categoryId);

    final CategoryManicure category =
        await CategoryManicure.getCategoryById(categoryId);

    final Directory appPath = await getApplicationDocumentsDirectory();

    final int _random = Random().nextInt(_manicure.length);

    final Manicure _result = _manicure[_random];

    String pathImage = appPath.path + "/" + _result.image;

    Map<String, dynamic> map = {
      "path": pathImage,
      "category": category,
    };

    print(map);

    return map;
  }

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> manicure = _getRandImage();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Твой маникюр",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: manicure,
          builder: (BuildContext context, AsyncSnapshot snape) {
            if (snape.hasData) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: CategoryView.fromHex(snape.data["category"].color),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.file(
                      File(snape.data["path"]),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
