import 'package:fim_dos_tempos_weekly/colors/custom_colors.dart';
import 'package:fim_dos_tempos_weekly/pages/home_page.dart';
import 'package:fim_dos_tempos_weekly/utils/datasource/firebase/FirebaseStore.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: CustomColors.customRed,
      ),
      home: HomePage(title: 'Home'),
    );
  }
}

