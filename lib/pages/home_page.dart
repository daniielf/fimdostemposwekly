import 'package:fim_dos_tempos_weekly/Mocks/mocks.dart';
import 'package:fim_dos_tempos_weekly/models/models.dart';
import 'package:fim_dos_tempos_weekly/utils/datasource/firebase/FirebaseStore.dart';
import 'package:flutter/material.dart';

import 'act_page.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Act> acts = Mocks.database();

  String getActTitle(int index) {
    return acts[index].name;
  }

  void presentAct(int index, BuildContext ctx) {
    Act selectedAct = acts[index];
    Navigator.of(ctx).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 350),
        reverseTransitionDuration: Duration(milliseconds: 250),
        pageBuilder: (context, a, b)  {
          return ActPage(title: selectedAct.name, chapters: selectedAct.chapters);
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Act>>(
      future: FirebaseManager.get(),
      builder: (BuildContext ctx, AsyncSnapshot<List<Act>> snapshot) {
        if (snapshot.data != null) {
          acts = snapshot.data!;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Fim dos Tempos"),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/papyrus.jpeg"),
                    fit: BoxFit.fill
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                        child: new ListView.builder(
                          padding: EdgeInsets.only(top: 40),
                          itemCount: acts.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return GestureDetector(
                              onTap: () {
                                presentAct(index, context);
                              },
                              child: Text(
                                getActTitle(index),
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    decorationStyle: TextDecorationStyle.solid
                                ),
                              ),
                            );
                          },
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    "assets/images/tormenta-logo.png",
                    height: 40,
                    width: double.infinity,
                  ),
                )
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      }
    );
  }
}
