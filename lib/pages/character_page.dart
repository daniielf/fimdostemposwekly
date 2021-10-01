import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/FirebaseStore.dart';
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Center(
                          child: Image.network(
                              widget.character.avatarUrl),
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
                    )
                  ],
                ),
              )
          ),
        )
    );
  }
}
