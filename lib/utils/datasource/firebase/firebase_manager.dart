import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:fimDosTemposWeekly/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseManager {

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

  static Future<List<Arc>> getArcs() async {
    List<Arc> arcs = List<Arc>.empty(growable: true);
    await _database.once().then((snapshot) {
      final reference = Map<String, dynamic>.from(snapshot.value);
      final arcsList = reference["arcs"];
      arcsList.forEach((actRef) {
        String name = actRef['name'];
        int index = actRef['index'];

        List<Chapter> chapters = List<Chapter>.empty(growable: true);
        final chaptersList = actRef['chapters'];

        chaptersList.forEach((chapterRef) {
          String title = chapterRef['title'];
          String duration = chapterRef['duration'];
          String releaseDate = chapterRef['releaseDate'];
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

          Chapter chapter = Chapter(index, title, paragraphs, videoUrl, duration, releaseDate);
          chapters.add(chapter);
        });

        final arc = Arc(index, name, chapters);
        arcs.add(arc);
      });
    }).catchError((error) {
      return error;
    });

    return arcs;
  }

  static Future<List<LinkPath>> getLinks() async {
    List<LinkPath> links = List.empty(growable: true);
    await _database.once().then((snapshot) {
      final reference = Map<String, dynamic>.from(snapshot.value);
      final linkList = reference["links"];
      linkList.forEach((linkRef) {
        String url = linkRef['url'];
        String assetPath = linkRef['assetPath'];

        links.add(LinkPath(assetPath, url));
      });
    });
    return links;
  }

  static Future<List<Character>> getCharacters() async {
    List<Character> characters = List.empty(growable: true);
    await _database.once().then((snapshot) {
      final reference = Map<String, dynamic>.from(snapshot.value);
      final characterList = reference["characters"];
      characterList.forEach((characterRef) {
        String name = characterRef['name'];
        String description = characterRef['description'];
        String iconUrl = characterRef['iconUrl'];
        String avatarUrl = characterRef['avatarUrl'];
        String pageUrl = characterRef['pageUrl'];
        String phrase = characterRef['phrase'];

        characters.add(Character(name, description, iconUrl, avatarUrl, pageUrl, phrase));
      });
    });

    characters.sort((a,b) =>  a.name.compareTo(b.name));
    return characters;
  }

  static Future<List<String>> getInformations() async {
    List<String> infos = List.empty(growable: true);
    await _database.once().then((snapshot) {
      final reference = Map<String, dynamic>.from(snapshot.value);
      final infoList = reference["infos"];
      infoList.forEach((info) {
        infos.add(info);
      });
    });
    return infos;
  }
  
  static DatabaseReference getTwitchLive() {
    return _database.child("twitchLive");
  }

  static Future<void> report(String text, String chapter) {
    String fullReportText = "Chapter $chapter: $text";
    return firestore.collection("reports").add({
          'text': fullReportText
        });
  }

  static Future<Chapter> getChapter(int arc, int chapterIndex) async {
    try {
      var snapshot = await _database.child("arcs").child("$arc").child("chapters").child("$chapterIndex").once();
      var chapterRef = snapshot.value;
      String title = chapterRef['title'];
      String duration = chapterRef['duration'];
      String releaseDate = chapterRef['releaseDate'];
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

      Chapter chapter = Chapter(index, title, paragraphs, videoUrl, duration, releaseDate);
      return chapter;
    } catch (error) {
      return Future.error(error);
    }
  }
}