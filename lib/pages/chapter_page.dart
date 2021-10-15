import 'package:fimDosTemposWeekly/colors/custom_colors.dart';
import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:fimDosTemposWeekly/utils/general_strings.dart';
import 'package:fimDosTemposWeekly/utils/share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef VoidCallback = void Function();

class ChapterPage extends StatefulWidget {
  ChapterPage(
      {Key? key,
      required this.chapterIndex,
      required this.arcIndex,
      required this.chaptersCount,
      this.onMarkChangeCallback})
      : super(key: key);

  final int chapterIndex;
  final int arcIndex;
  final int chaptersCount;
  VoidCallback? onMarkChangeCallback;

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {

  bool isMarked = false;
  bool isLoading = true;
  bool hasError = false;
  String reportInput = "";
  Chapter? chapter;

  @override
  void initState() {
    loadChapter();
    super.initState();
  }

  void loadMarkedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? selectedMark = prefs.getInt("markedPage");
    setState(() {
      isMarked = selectedMark == widget.chapterIndex;
    });
  }

  String getParagraph(int index) {
    return chapter?.paragraphs[index].text ?? "";
  }

  void presentPrevious(BuildContext ctx) {
    int currentIndex = widget.chapterIndex;
    if (hasPrevious()) {
      presentChapter(currentIndex - 1, ctx);
    }
  }

  void presentNext(BuildContext ctx) {
    int currentIndex = widget.chapterIndex;
    if (hasNext()) {
      presentChapter(currentIndex + 1, ctx);
    }
  }

  void saveMarker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isMarked) {
      await prefs.remove('markedPage');
    } else {
      await prefs.setInt('markedPage', widget.chapterIndex);
    }
    loadMarkedPage();

    if (widget.onMarkChangeCallback != null) {
      widget.onMarkChangeCallback!();
    }
    Navigator.pop(context);
  }

  bool hasPrevious() {
    return widget.chaptersCount > 1 && widget.chapterIndex - 1 >= 0;
  }

  bool hasNext() {
    return widget.chapterIndex < widget.chaptersCount - 1;
  }

  void reportChapter() {
    presentLoadingAlert();
    FirebaseManager.report(this.reportInput, "${widget.chapterIndex + 1}")
        .then((value) {
      Navigator.of(context).pop();
      this.reportInput = "";
      this.presentSuccessReportAlert();
    }).catchError((onError) {
      Navigator.of(context).pop();
      this.presentErrorReportAlert();
    });
  }

  void presentLoadingAlert() {
    AlertDialog alert = AlertDialog(
      content: SizedBox(
        height: 45,
        width: 45,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void presentSuccessReportAlert() {
    AlertDialog alert = AlertDialog(
      title: Text("Sucesso"),
      content: Text("Comentário enviado com sucesso!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("Ok")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void presentErrorReportAlert() {
    AlertDialog alert = AlertDialog(
      title: Text("Falha"),
      content: Text(
          "Não foi possível enviar sua mensagem! Tente novamente mais tarde."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              presentReportDialog();
            },
            child: Text("Ok")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void presentReportDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Enviar comentário"),
      content: TextField(
        maxLines: 3,
        controller: TextEditingController(text: this.reportInput),
        onChanged: (text) {
          this.reportInput = text;
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              reportChapter();
            },
            child: Text("Enviar")),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void loadChapter() async {
    FirebaseManager.getChapter(widget.arcIndex, widget.chapterIndex)
        .then((chapter) {
      setState(() {
        isLoading = false;
        hasError = false;
        loadMarkedPage();
        this.chapter = chapter;
      });
    }).catchError((_) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }).whenComplete(() => isLoading = false);
  }

  void presentChapter(int chapterIndex, BuildContext ctx) {
    PageRouteBuilder nextRoute = PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 350),
      reverseTransitionDuration: Duration(milliseconds: 250),
      pageBuilder: (context, a, b) {
        return ChapterPage(
            chapterIndex: chapterIndex,
            arcIndex: widget.arcIndex,
            chaptersCount: widget.chaptersCount);
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );

    Navigator.pushReplacement(ctx, nextRoute);
  }

  _launchURL() async {
    String url = chapter?.videoUrl ?? "";
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
          title: Text("Capítulo ${widget.chapterIndex + 1}"),
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
                  child: Text(
                    "Menu",
                    style: TextStyle(fontSize: 36, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                        child: GestureDetector(
                          onTap: saveMarker,
                          child: Row(children: [
                            Image.asset(
                              "assets/images/arrow-right.png",
                              width: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${isMarked ? "Remover" : "Colocar"} Marcador",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            ShareManager.share(widget.arcIndex,
                                widget.chapterIndex, chapter?.title ?? "");
                          },
                          child: Row(children: [
                            Image.asset(
                              "assets/images/arrow-right.png",
                              width: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Compartilhar",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 10),
                        child: GestureDetector(
                          onTap: presentReportDialog,
                          child: Row(children: [
                            Image.asset(
                              "assets/images/arrow-right.png",
                              width: 24,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "Reportar Problema",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  "Detalhes do Episódio",
                  style: TextStyle(fontSize: 24, color: Colors.white60),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Dia de Lançamento: ${chapter?.releaseDate ?? ""}",
                    style: TextStyle(fontSize: 18, color: Colors.white60),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Duração do Episódio: ${chapter?.duration ?? ""}",
                    style: TextStyle(fontSize: 18, color: Colors.white60),
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
                  fit: BoxFit.fill)),
          child: (isLoading
              ? Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 5,
                    ),
                    height: 40,
                    width: 40,
                  ),
                )
              :
              (hasError ? Center(
                      child: Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
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
                                ]),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 5, left: 30, right: 30),
                          child: Column(
                            children: [
                              Text(chapter?.title ?? "",
                                  style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              isMarked
                                  ? Image.asset(
                                      "assets/images/bookmark.png",
                                      height: 20,
                                    )
                                  : SizedBox(),
                            ],
                          )),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: chapter?.paragraphs.length ?? 0,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        ]);
                                  },
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 40),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) {
                                return (hasPrevious()
                                    ? Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            presentPrevious(context);
                                          },
                                          child: Text(
                                            "< Anterior",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: Text("")));
                              },
                            ),
                            Expanded(child:
                              GestureDetector(
                                onTap: _launchURL,
                                child: Image.asset(
                                  "assets/images/yt-icon.png",
                                  height: 40,
                                ),
                              )),
                            Builder(
                              builder: (context) {
                                return (hasNext()
                                    ? Expanded(
                                        child: GestureDetector(
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : Expanded(child: Text("")));
                              },
                            ),
                          ],
                        ),
                      )
                    ])
            )
          )
        ),
      )
    );
  }
}
