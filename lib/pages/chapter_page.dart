import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterPage extends StatefulWidget {

  ChapterPage({Key? key, required this.title, required this.chapter, required this.chaptersList }) : super(key: key);

  final String title;
  final Chapter chapter;
  final List<Chapter> chaptersList;

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {

  String getParagraph(int index) {
    return widget.chapter.paragraphs[index].text;
  }

  void presentPrevious(BuildContext ctx) {
    int currentIndex = widget.chapter.index;
    if (currentIndex != 0 &&
        currentIndex - 1 >= 0) {
      Chapter previousReference = widget.chaptersList[currentIndex - 1];
      presentChapter(previousReference, ctx);
    }
  }

  void presentNext(BuildContext ctx) {
    int currentIndex = widget.chapter.index;
    if (currentIndex < widget.chaptersList.length - 1) {
      Chapter nextReference = widget.chaptersList[currentIndex + 1];
      presentChapter(nextReference, ctx);
    }
  }

  bool hasPrevious() {
    return widget.chapter.index - 1 >= 0;
  }

  bool hasNext() {
    return widget.chapter.index < widget.chaptersList.length - 1;
  }

  void presentChapter(Chapter chapter, BuildContext ctx) {
      PageRouteBuilder nextRoute =  PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 350),
        reverseTransitionDuration: Duration(milliseconds: 250),
        pageBuilder: (context, a, b)  {
          return ChapterPage(title: "Capítulo ${chapter.index + 1}", chapter: chapter, chaptersList: widget.chaptersList);
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );

      Navigator.pushReplacement(ctx, nextRoute);
  }

  _launchURL() async {
    String url = widget.chapter.videoUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                      widget.chapter.title,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: widget.chapter.paragraphs.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(
                                getParagraph(index),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic,
                                ),
                              ),
                                SizedBox(height: 50)
                            ]
                            );
                          },
                        ),
                      ),
                    )
                 ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                  child: Row(
                    children: [
                      Builder(builder: (context) {
                        return (hasPrevious() ?
                        Expanded(child:
                        GestureDetector(
                          onTap: () {
                            presentPrevious(context);
                          },
                          child: Text(
                            "< Anterior",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        ) :
                        Expanded(child: Text("")));
                      },
                      ),
                      Expanded(child:
                          GestureDetector(
                            onTap: _launchURL,
                            child: Image.asset(
                              "assets/images/yt-icon.png",
                              height: 40,
                            ),
                          )
                      ),
                      Builder(builder: (context) {
                        return (hasNext() ?
                        Expanded(child:
                        GestureDetector(
                          onTap: () {
                            presentNext(context);
                          },
                          child: Text(
                            "Próximo >",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        ) :
                        Expanded(child: Text("")));
                      },
                      ),
                    ],
                  ),
                )
              ]
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
