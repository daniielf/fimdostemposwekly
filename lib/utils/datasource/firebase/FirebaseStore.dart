import 'dart:collection';
import 'dart:convert';

import 'package:fim_dos_tempos_weekly/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseManager {

  static FirebaseApp app = Firebase.app("FimDosTemposWeekly_iOS");
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _database = FirebaseDatabase.instance.reference();

  static start() async {
    try {
      await Firebase.initializeApp();
      print("Start Firebase");
    } catch(e) {
      print("Couldn't be started $e");
    }
  }

  static Future<List<Act>> get() async {
    List<Act> acts = List<Act>.empty(growable: true);
    await _database.once().then((snapshot) {
      final reference = Map<String, dynamic>.from(snapshot.value);
      final actsList = reference["acts"];
      actsList.forEach((actRef) {
        String name = actRef['name'];
        int index = actRef['index'];

        List<Chapter> chapters = List<Chapter>.empty(growable: true);
        final chaptersList = actRef['chapters'];

        chaptersList.forEach((chapterRef) {
          String title = chapterRef['title'];
          String videoUrl = chapterRef['videoUrl'];
          int index = chapterRef['index'];

          List<Paragraph> paragraphs = List<Paragraph>.empty(growable: true);
          final paragraphList = chapterRef['paragraphs'];

          paragraphList.forEach((paragRef) {
            String text = paragRef['text'];
            int index = paragRef['index'];
            final paragraph = Paragraph(index, text);
            paragraphs.add(paragraph);
          });

          Chapter chapter = Chapter(index, title, paragraphs, videoUrl);
          chapters.add(chapter);
        });

        final act = Act(index, name, chapters);
        acts.add(act);
      });
    });
    return acts;
  }
}