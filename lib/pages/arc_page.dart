import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chapter_page.dart';

class ActPage extends StatefulWidget {

  ActPage({
    Key? key,
    required this.title,
    required this.chapters,
    required this.arcIndex
  }) : super(key: key);

  final String title;
  final List<Chapter> chapters;
  final int arcIndex;

  @override
  _ActPageState createState() => _ActPageState();
}

class _ActPageState extends State<ActPage> {

  int? markedPage;
  List<Chapter> filteredChapters = [];
  bool isSearchOpen = false;
  String currentSearch = "";

  @override
  initState() {
    loadMarkedPage();
    filteredChapters = widget.chapters;
    super.initState();
  }

  String getChapterTitle(int index) {
    String baseTitle = "Capítulo ${index + 1}: ${filteredChapters[index].title}";
    return baseTitle;
  }

  void loadMarkedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.markedPage = prefs.getInt("markedPage");
    setState(() { });
  }

  void markChanged() {
    loadMarkedPage();
  }

  void presentChapter(int index, BuildContext ctx) {
    Chapter selectedChapter = filteredChapters[index];
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>
        ChapterPage(
          chapterIndex: selectedChapter.index,
          arcIndex: widget.arcIndex,
          chaptersCount: widget.chapters.length,
          onMarkChangeCallback: markChanged)
        ),
    );
  }

  void updateFilteredChapters() {
    setState(() {
      filteredChapters = widget.chapters.where((chapter) {
        if (currentSearch.isEmpty) {
          return true;
        } else {
          return chapter.title.toLowerCase().contains(currentSearch.toLowerCase());
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
              child:
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(35, 35, 35, 0.4),
                            width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              children: [
                                Image.asset(
                                    "assets/images/tormenta.png",
                                height: 32,
                                width: 32,),
                                SizedBox(width: 16),
                                Expanded(child:
                                  TextField(
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Buscar capítulo...",
                                    ),
                                    autocorrect: false,
                                    onChanged: (text) {
                                      this.currentSearch = text;
                                      this.updateFilteredChapters();
                                    },
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: new ListView.builder(
                      padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                      itemCount: filteredChapters.length,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  ),
                    ),
                ])
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
