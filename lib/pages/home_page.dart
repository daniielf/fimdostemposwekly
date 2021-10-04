import 'dart:async';

import 'package:fimDosTemposWeekly/pages/arc_list_page.dart';
import 'package:fimDosTemposWeekly/pages/character_list_page.dart';
import 'package:fimDosTemposWeekly/pages/informative_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/FirebaseStore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isTwitchLive = false;
  StreamSubscription? isTwitchLiveSubscription;

  void presentAct() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 350),
        reverseTransitionDuration: Duration(milliseconds: 250),
        pageBuilder: (context, a, b)  {
          return ArcListPage(title: "Arcos");
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

  void presentCharacterList() {
    Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 350),
          reverseTransitionDuration: Duration(milliseconds: 250),
          pageBuilder: (context, a, b)  {
            return CharacterListPage(title: "Personagens");
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

  void presentInformative() {
    PageRouteBuilder nextRoute =  PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 350),
      reverseTransitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, a, b)  {
        return InformativePage(title: "Informações");
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );

    Navigator.push(context, nextRoute);
  }

  openLiveTwitch() async {
    String url = "https://www.twitch.tv/jamboeditora";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void startObservingTwitch() {
    if (isTwitchLiveSubscription != null) { return; }
    isTwitchLiveSubscription = FirebaseManager.getTwitchLive().onValue.listen((event) {
      if (event.snapshot.value is bool) {
        bool newValue = event.snapshot.value;
        setState(() {
          this.isTwitchLive = newValue;
        });
      } else {
        print ("IS NOT BOOL");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startObservingTwitch();
     return Scaffold(
          appBar: AppBar(
            title: Text("Fim dos Tempos"),
          ),
          floatingActionButton: isTwitchLive ? 
            FloatingActionButton(
              onPressed: openLiveTwitch,
              backgroundColor: Colors.transparent,
              child:
                Image.asset(
                  "assets/images/twitch-alert.png",
                height: 64),
            ) :
            SizedBox(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
                SizedBox(height: 40),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("História",
                                style: TextStyle(
                                fontSize: 24,
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                decorationStyle: TextDecorationStyle.solid
                            ),
                    ),
                  ),
                  onTap: presentAct,

                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Personagens",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          decorationStyle: TextDecorationStyle.solid
                      ),),
                  ),
                  onTap: presentCharacterList,
                ),
                Expanded(
                  child: SizedBox()
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: GestureDetector(
                    onTap: presentInformative,
                    child: Image.asset(
                      "assets/images/tormenta-logo.png",
                      height: 40,
                      width: double.infinity,
                    ),
                  ),
                )
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
