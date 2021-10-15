import 'dart:async';
import 'package:fimDosTemposWeekly/pages/arc_list_page.dart';
import 'package:fimDosTemposWeekly/pages/character_list_page.dart';
import 'package:fimDosTemposWeekly/pages/informative_page.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:fimDosTemposWeekly/utils/deeplink/deeplink_resolver.dart';
import 'package:fimDosTemposWeekly/utils/notification/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

import 'chapter_page.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isTwitchLive = false;
  StreamSubscription? isTwitchLiveSubscription;

  @override
  void initState() {
    super.initState();
    setUp();
  }

  void setUp() async {
    startObservingTwitch();
    getInitialDeeplink();
    getFirebaseNotifications();
    startListeningFirebaseMessages();
  }

  void getFirebaseNotifications() {
    NotificationManager.getFirebaseStartMessages((String deeplinkUri) {
      var path = DeeplinkResolver.getPath(deeplinkUri);
      var arc = path["arc"];
      var chapter = path["chapter"];
      if (arc != null && chapter != null) {
        presentChapter(arc, chapter);
      }
    });
  }

  void startListeningFirebaseMessages() {
    NotificationManager.getFirebaseMessages((deeplinkUri) {
      var path = DeeplinkResolver.getPath(deeplinkUri);
      var arc = path["arc"];
      var chapter = path["chapter"];
      if (arc != null && chapter != null) {
        presentChapter(arc, chapter);
      }
    });
  }

  void getInitialDeeplink() async {
    try {
      var initialLink = await getInitialLink() ?? "";
      var path = DeeplinkResolver.getPath(initialLink);
      var arc = path["arc"];
      var chapter = path["chapter"];
      if (arc != null && chapter != null) {
        Timer.periodic(Duration(milliseconds: 600), (timer) {
          presentChapter(arc, chapter);
          timer.cancel();
        });
      }
    } catch (error) {
      print (error);
    }
  }

  openLiveTwitch() async {
    String url = "https://www.twitch.tv/jamboeditora";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void startObservingTwitch() async {
    if (isTwitchLiveSubscription != null) { return; }
    isTwitchLiveSubscription = FirebaseManager.getTwitchLive().onValue.listen((event) {
      if (event.snapshot.value is bool) {
        bool newValue = event.snapshot.value;
        setState(() {
          this.isTwitchLive = newValue;
        });
      }
    });
  }

  void presentAct() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>ArcListPage(title: "Arcos"))
    );
  }

  void presentCharacterList() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => CharacterListPage(title: "Personagens")),
    );
  }

  void presentInformative() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => InformativePage(title: "Informações")),
    );
  }

  void presentChapter(int arc, int chapter) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
            ChapterPage(
                chapterIndex: chapter,
                arcIndex: arc,
                chaptersCount: 0)
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 16, bottom: 2, right: 64),
                  child: GestureDetector(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/histories-banner.png",
                          fit: BoxFit.scaleDown,
                        )
                    ),
                    onTap: presentAct,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 64, bottom: 2, right: 16),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                          "assets/images/characters-banner.png",
                        fit: BoxFit.scaleDown,
                      )
                    ),
                    onTap: presentCharacterList,
                  ),
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
