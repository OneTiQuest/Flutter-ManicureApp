import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/CategoryPage.dart';
import 'package:flutter_app/data/CategoryData.dart';
import 'package:flutter_app/models/CategoryManicure.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'models/Manicure.dart';
import 'models/db.dart';

class CategoryView extends StatelessWidget {
  CategoryManicure category;

  CategoryView({@required this.category});

  Future<dynamic> _getPathImage() async {
    final Directory appPath = await getApplicationDocumentsDirectory();
    return appPath.path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await DB.delete(CategoryManicure.table, category);
        final List<Manicure> manicureList =
            await Manicure.getManicureById(category.id);
        String appPath = await _getPathImage();

        if (manicureList != null) {
          manicureList.forEach((element) {
            File file = File(appPath + element.image);
            DB.delete(Manicure.table, element);
            file.delete();
          });
        }

        context
            .read<CategoryData>()
            .changeData(CategoryManicure.getCategories());

        Fluttertoast.showToast(
          msg: "Категория удалена",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => CategoryPage(category.id))),
      child: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: 80,
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: fromHex("#D7DBDD"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Text(
                        category.name,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Дизайн: ",
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            CategoryManicure.getDesign(category.design),
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: fromHex(category.color),
                      border: Border.all(color: Colors.blueGrey)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static fromHex(String hex) {
    String hexColor = hex.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x" + hexColor));
    }
  }
}
