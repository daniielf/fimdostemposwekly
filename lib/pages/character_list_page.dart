import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/pages/character_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:flutter/material.dart';
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
              title: Text("Personagens"),
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
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                          child:
                          new ListView.builder(
                            padding: EdgeInsets.only(top: 40),
                            itemCount: characters.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
                              child: GestureDetector(
                                onTap: () => presentChracter(index),
                                child: Row(
                                  children: [
                                    Image.asset
                                      ("assets/images/" + characters[index].iconUrl,
                                      height: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(characters[index].name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                decorationStyle: TextDecorationStyle.solid)
                                          ),
                                          Text(characters[index].description,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  decorationStyle: TextDecorationStyle.solid)
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
  }
}
