import 'package:flutter/material.dart';
import 'package:warehouse_management_app/screens/addOwnerPage.dart';
import 'package:warehouse_management_app/theme/color.dart';
import 'package:warehouse_management_app/theme/string.dart';
import 'package:warehouse_management_app/theme/theme.dart';
import 'package:warehouse_management_app/uiwidget/robotoTextWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home:  MyHomePage(title: appName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>  AddOwnerPage()),
            (Route<dynamic> route) => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: robotoTextWidget(textval: appName, colorval: AppColor.whiteColor, sizeval: 16, fontWeight: FontWeight.w800),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            robotoTextWidget(textval: noDataAvailable, colorval: AppColor.themeColor, sizeval: 14, fontWeight: FontWeight.w400)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: addProduct,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
