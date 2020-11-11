import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/CategoryData.dart';
import 'package:flutter_app/models/CategoryManicure.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

import 'models/db.dart';

class CreateCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  Color color = Colors.blue;
  String name;
  String design = '0';
  Color pickerColor = Colors.redAccent;

  final controller = TextEditingController();

  void changeColor(Color color) {
    setState(() => {pickerColor = color, controller.text = name});
  }

  void _save(TextEditingController contr) async {
    if (contr.text.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Ошибка!"),
          content: Text("Категория не названа."),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ок"))
          ],
          elevation: 24,
        ),
        barrierDismissible: false,
      );
      return;
    }

    setState(() => color = pickerColor);

    CategoryManicure item = CategoryManicure(
      design: design,
      name: contr.text,
      color: '#${color.value.toRadixString(16).substring(2)}',
    );

    try {
      await DB.insert(CategoryManicure.table, item);
      context.read<CategoryData>().changeData(CategoryManicure.getCategories());
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<S2Choice<String>> options = [
      S2Choice<String>(value: '1', title: 'Втирка'),
      S2Choice<String>(value: '2', title: 'Кошачий глаз'),
      S2Choice<String>(value: '3', title: 'Геометрия'),
      S2Choice<String>(value: '4', title: 'Градиент'),
      S2Choice<String>(value: '5', title: 'Флора'),
      S2Choice<String>(value: '6', title: 'Фауна'),
      S2Choice<String>(value: '7', title: 'Стразы'),
      S2Choice<String>(value: '8', title: 'Френч'),
      S2Choice<String>(value: '9', title: 'Разное'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Создание категории",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SmartSelect<String>.single(
                modalType: S2ModalType.bottomSheet,
                title: 'Дизайн',
                placeholder: "Выбрать",
                value: design,
                choiceItems: options,
                onChange: (state) => setState(() => design = state.value),
              ),
              Container(
                child: MaterialPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: RaisedButton(
                  child: Text(
                    "Сохранить",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                  onPressed: () => _save(controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
