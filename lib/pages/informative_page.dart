import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:fimDosTemposWeekly/utils/datasource/firebase/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformativePage extends StatefulWidget {

  InformativePage({Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  _InformativePageState createState() => _InformativePageState();
}

class _InformativePageState extends State<InformativePage> {

  List<LinkPath> links = [];
  List<String> infos = [];

  openLink(int index) async {
    String url = links[index].url;
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
              )),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 30),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<String>>(
                        future: FirebaseManager.getInformations(),
                        builder: (BuildContext ctx, AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.data != null) {
                            infos = snapshot.data!;
                          }
                          return Column(
                            children: List.generate(infos.length,
                                                    (index) => Column(
                                                                children: [
                                                                  Text(infos[index],
                                                                      style: TextStyle(
                                                                          fontSize: 18,
                                                                          color: Colors.black87,
                                                                          fontWeight: FontWeight.bold,
                                                                          decorationStyle: TextDecorationStyle.solid)
                                                                  ),
                                                                  SizedBox(height: 20),
                                                                ],
                                                              )
                            ),
                          );
                        }
                    ),
                    SizedBox(height: 25),
                    FutureBuilder<List<LinkPath>>(
                          future: FirebaseManager.getLinks(),
                          builder: (BuildContext ctx, AsyncSnapshot<List<LinkPath>> snapshot) {
                            if (snapshot.data != null) {
                              links = snapshot.data!;
                            }
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                        links.length,
                                        (index) => GestureDetector(
                                                    onTap: () => openLink(index),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage("assets/images/${links[index].assetPath}"),
                                                                fit: BoxFit.scaleDown
                                                            )
                                                        )
                                                    ),
                                                  ),
                                ),
                              )
                              ),
                            );
                    }),
                  ],
                ),
              )
          ),
        )
      );
  }
}
