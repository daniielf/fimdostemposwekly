import 'package:fimDosTemposWeekly/colors/custom_colors.dart';
import 'package:fimDosTemposWeekly/pages/home_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/FirebaseStore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseManager.start();
  runApp(MyApp());
}

void startFirebase() async {

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FimDosTempos Weekly',
      theme: ThemeData(
        primarySwatch: CustomColors.customRed,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

