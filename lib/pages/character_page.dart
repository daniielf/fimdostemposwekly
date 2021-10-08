import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:fimDosTemposWeekly/utils/general_strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CharacterPage extends StatefulWidget {

  CharacterPage({Key? key, required this.character }) : super(key: key);

  final Character character;

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {

  openLink() async {
    String url = widget.character.pageUrl;
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
          title: Text(widget.character.name),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/papyrus.jpeg"),
                  fit: BoxFit.fill
              )),
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 30),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Center(
                          child:
                          Image.network(
                              widget.character.avatarUrl,
                              errorBuilder: (context, url, error) {
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/image-error.png"),
                                      SizedBox(height: 16),
                                      SizedBox(
                                        width: 240,
                                        child: Text(
                                          GeneralStrings.imageError,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      )
                                    ]
                                );
                              },
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }

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
                              }
                            )
                        ),
                      ),
                    ),
                    Text(
                      "\"${widget.character.phrase}\"",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontStyle: FontStyle.italic,
                          decorationStyle: TextDecorationStyle.solid)
                    ),
                    SizedBox(height: 36),
                    Center(
                      child: GestureDetector(
                        child: Image.asset(
                            "assets/images/character-sheet.png",
                          height: 48,
                        ),
                        onTap: openLink,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              )
          ),
        )
    );
  }
}
