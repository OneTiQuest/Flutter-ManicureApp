import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'App.dart';
import 'CreateCategory.dart';
import 'data/CategoryData.dart';
import 'models/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryData>(
      create: (context) => CategoryData(),
      lazy: true,
      child: MaterialApp(
        initialRoute: "/",
        routes: {
          "/": (context) => App(),
          "/create-cat": (context) => CreateCategory(),
        },
        title: "Маникюр",
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
      ),
    );
  }
}
