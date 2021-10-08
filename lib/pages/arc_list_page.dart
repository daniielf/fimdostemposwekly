import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/pages/informative_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:fimDosTemposWeekly/utils/general_strings.dart';
import 'package:flutter/material.dart';

import 'arc_page.dart';

class ArcListPage extends StatefulWidget {

  ArcListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ArcListPageState createState() => _ArcListPageState();
}

class _ArcListPageState extends State<ArcListPage> {

  List<Arc> acts = [];
  bool isError = false;

  String getActTitle(int index) {
    return acts[index].name;
  }

  void presentAct(int index, BuildContext ctx) {
    Arc selectedAct = acts[index];
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ActPage(title: selectedAct.name, chapters: selectedAct.chapters)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("História"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/papyrus.jpeg"),
                fit: BoxFit.fill
            )
        ),
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
                      child:
                      FutureBuilder<List<Arc>>(
                        future: FirebaseManager.getArcs(),
                        builder: (BuildContext ctx, AsyncSnapshot<List<Arc>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: SizedBox(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 5,
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                              );
                            case ConnectionState.done:
                              if (snapshot.data != null) {
                                acts = snapshot.data!;
                                return new ListView.builder(
                                  padding: EdgeInsets.only(top: 40),
                                  itemCount: acts.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        presentAct(index, context);
                                      },
                                      child: Row(
                                          children: [
                                            Image.asset("assets/images/page-scroll.png", height: 20,),
                                            SizedBox(width: 15),
                                            Text(
                                              getActTitle(index),
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black87,
                                                  fontStyle: FontStyle.italic,
                                                  decoration: TextDecoration.underline,
                                                  fontWeight: FontWeight.bold,
                                                  decorationStyle: TextDecorationStyle.solid
                                              ),
                                            )
                                          ]
                                      ),
                                    );
                                  },
                                );
                              }

                              if (snapshot.error != null) {
                                return Center(
                                  child: Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: GestureDetector(
                                        onTap: (){ setState(() {

                                        }); },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/load-error.png"),
                                            SizedBox(height: 16),
                                            SizedBox(
                                              width: 240,
                                              child: Text(
                                                GeneralStrings.errorMessage,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                ),
                                              ),
                                            )
                                          ]
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            default:
                              break;
                          }
                          return Container();
                        }
                      )
                  )
                )
              )
            ]
          )
      )
    );

    // return FutureBuilder<List<Arc>>(
    //     future: FirebaseManager.getArcs(),
    //     builder: (BuildContext ctx, AsyncSnapshot<List<Arc>> snapshot) {
    //
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return Center(
    //             child: SizedBox(
    //               child: CircularProgressIndicator(
    //                 color: Colors.red,
    //                 strokeWidth: 5,
    //               ),
    //               height: 40,
    //               width: 40,
    //             ),
    //           );
    //         case ConnectionState.done:
    //           if (snapshot.data != null) {
    //             acts = snapshot.data!;
    //           }
    //
    //           if (snapshot.error != null) {
    //             return Center(
    //               child: Expanded(
    //                 child: Padding(
    //                   padding: EdgeInsets.all(16),
    //                   child: Image.asset("assets/images/load-error.png"),
    //                 ),
    //               ),
    //             );
    //           }
    //
    //           return Scaffold(
    //             appBar: AppBar(
    //               title: Text("História"),
    //             ),
    //             body: Container(
    //               decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                       image: AssetImage("assets/images/papyrus.jpeg"),
    //                       fit: BoxFit.fill
    //                   )
    //               ),
    //               child:
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Expanded(
    //                     child: Center(
    //                       child: Padding(
    //                           padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
    //                           child: new ListView.builder(
    //                             padding: EdgeInsets.only(top: 40),
    //                             itemCount: acts.length,
    //                             itemBuilder: (BuildContext ctxt, int index) {
    //                               return GestureDetector(
    //                                 onTap: () {
    //                                   presentAct(index, context);
    //                                 },
    //                                 child: Row(
    //                                     children: [
    //                                       Image.asset("assets/images/page-scroll.png", height: 20,),
    //                                       SizedBox(width: 15),
    //                                       Text(
    //                                         getActTitle(index),
    //                                         style: TextStyle(
    //                                             fontSize: 24,
    //                                             color: Colors.black87,
    //                                             fontStyle: FontStyle.italic,
    //                                             decoration: TextDecoration.underline,
    //                                             fontWeight: FontWeight.bold,
    //                                             decorationStyle: TextDecorationStyle.solid
    //                                         ),
    //                                       )
    //                                     ]
    //                                 ),
    //                               );
    //                             },
    //                           )
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ), // This trailing comma makes auto-formatting nicer for build methods.
    //           );
    //         default:
    //
    //       }
    //     }
    // );
  }
}
