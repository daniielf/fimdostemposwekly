import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/pages/character_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/FirebaseStore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CharacterListPage extends StatefulWidget {

  CharacterListPage({Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {

  List<Character> characters = [];

  openLink(int index) async {
    String url = characters[index].pageUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void presentChracter(int index) {
    Character character = characters[index];
    Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 350),
          reverseTransitionDuration: Duration(milliseconds: 250),
          pageBuilder: (context, a, b) {
            return CharacterPage(character: character);
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation, Animation<double> secondaryAnimation,
              Widget child) {
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
    return FutureBuilder<List<Character>>(
        future: FirebaseManager.getCharacters(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Character>> snapshot) {
          if (snapshot.data != null) {
            characters = snapshot.data!;
          }
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
                          itemCount: characters.length,
                          itemBuilder: (BuildContext ctxt, int index) {

                            return Column(
                              children: [
                                GestureDetector(
                                  child: Image.asset
                                    ("assets/images/" + characters[index].iconUrl,
                                    height: 60,
                                  ),
                                  onTap: () => presentChracter(index),
                                ),
                                Text(characters[index].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        decorationStyle: TextDecorationStyle.solid)
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          })
                      ),
                    ),
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        }
    );
    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text(widget.title),
    //     ),
    //     body: Container(
    //       decoration: BoxDecoration(
    //           image: DecorationImage(
    //               image: AssetImage("assets/images/papyrus.jpeg"),
    //               fit: BoxFit.fill
    //           )),
    //       child: Container(
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //           child: Padding(
    //             padding: const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 30),
    //             child:  Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 FutureBuilder<List<Character>>(
    //                     future: FirebaseManager.getCharacters(),
    //                     builder: (BuildContext ctx, AsyncSnapshot<List<Character>> snapshot) {
    //                       if (snapshot.data != null) {
    //                         characters = snapshot.data!;
    //                       }
    //                       return new ListView.builder(
    //                         padding: EdgeInsets.only(top: 40),
    //                         itemCount: characters.length,
    //                         itemBuilder: (BuildContext ctxt, int index) {
    //
    //                           return Column(
    //                             children: [
    //                               GestureDetector(
    //                                 child: Image.asset
    //                                   ("assets/images/" + characters[index].iconUrl,
    //                                   height: 60,
    //                                 ),
    //                                 onTap: () => presentChracter(index),
    //                               ),
    //                               Text(characters[index].name,
    //                                   style: TextStyle(
    //                                       fontSize: 18,
    //                                       color: Colors.black87,
    //                                       fontWeight: FontWeight.bold,
    //                                       decorationStyle: TextDecorationStyle.solid)
    //                               ),
    //                               SizedBox(height: 20),
    //                             ],
    //                           );
    //                         });
    //                     }
    //                 ),
    //               ],
    //             ),
    //           )
    //       ),
    //     )
    // );
  }
}
