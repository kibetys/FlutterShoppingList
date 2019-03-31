import 'package:flutter/material.dart';
import 'package:flutter_app/util/dbhelper.dart';
import 'package:flutter_app/screens/shoppinglist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();
    helper.initializeDb().then(
        (result) => helper.getShopItems().then((result) => result));

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Shoppinglist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShopList(),
    );
  }
}
