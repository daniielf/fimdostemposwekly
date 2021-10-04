import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chapter_page.dart';

class ActPage extends StatefulWidget {

  ActPage({Key? key, required this.title, required this.chapters}) : super(key: key);

  final String title;
  final List<Chapter> chapters;

  @override
  _ActPageState createState() => _ActPageState();
}

class _ActPageState extends State<ActPage> {

  int? markedPage;

  String getChapterTitle(int index) {
    String baseTitle = "Capítulo ${index + 1}: ${widget.chapters[index].title}";
    return baseTitle;
  }

  void loadMarkedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    markedPage = await prefs.getInt("markedPage");
    setState(() { });
  }

  void presentChapter(int index, BuildContext ctx) {
    Chapter selectedChapter = widget.chapters[index];
    Navigator.of(ctx).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 350),
          reverseTransitionDuration: Duration(milliseconds: 250),
          pageBuilder: (context, a, b)  {
            return ChapterPage(title: "Capítulo ${selectedChapter.index + 1}", chapter: selectedChapter, chaptersList: widget.chapters);
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
    loadMarkedPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/papyrus.jpeg"),
                fit: BoxFit.fill
            )
        ),
        child:
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
              child: new ListView.builder(
                padding: EdgeInsets.only(top: 40),
                itemCount: widget.chapters.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return GestureDetector(
                    onTap: () => presentChapter(index, ctxt),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            index == markedPage ?
                            Image.asset("assets/images/bookmark.png", height: 20,) :
                            Image.asset("assets/images/page-scroll.png", height: 20,),
                            SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                getChapterTitle(index),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ]
                        ),
                        SizedBox(height: 50)
                      ]
                    ),
                  );
                },
              )
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
