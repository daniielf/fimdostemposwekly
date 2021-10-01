import 'package:fimDosTemposWeekly/colors/custom_colors.dart';
import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterPage extends StatefulWidget {

  ChapterPage({Key? key, required this.title, required this.chapter, required this.chaptersList }) : super(key: key);

  final String title;
  final Chapter chapter;
  final List<Chapter> chaptersList;

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {

  bool isMarked = false;

  void loadMarkedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? selectedMark = await prefs.getInt("markedPage");
    isMarked = selectedMark == widget.chapter.index;
    setState(() { });
  }

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

  void saveMarker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isMarked) {
      await prefs.remove('markedPage');
    } else {
      await prefs.setInt('markedPage', widget.chapter.index);
    }
    Navigator.pop(context);
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
      loadMarkedPage();
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        endDrawer: Drawer(
          child: Container(
            color: CustomColors.customRed,
            child: Column(
              children: [
                DrawerHeader(
                  child:  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: saveMarker,
                            child: Text(
                            "> ${isMarked ? "Remover" : "Salvar"} Marcador",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Text(
                            "> Reportar Problema",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  "Detalhes do Episódio",
                  style:
                    TextStyle(
                      fontSize: 24,
                      color: Colors.white60),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Dia de Lançamento: ${widget.chapter.releaseDate}",
                    style:
                    TextStyle(
                        fontSize: 18,
                        color: Colors.white60),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Duração do Episódio: ${widget.chapter.duration}",
                    style:
                    TextStyle(
                        fontSize: 18,
                        color: Colors.white60),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
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
                  padding: const EdgeInsets.only(top: 30, bottom: 5, left: 30, right: 30),
                  child: Column(
                    children: [
                      Text(
                        widget.chapter.title,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)
                    ),
                      SizedBox(height: 10),
                      isMarked ? Image.asset("assets/images/bookmark.png", height: 20,) : SizedBox(),
                    ],
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
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
