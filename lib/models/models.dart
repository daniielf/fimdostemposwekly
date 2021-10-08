class Arc {

  int index;
  String name;
  List<Chapter> chapters = List<Chapter>.empty(growable: true);

  Arc(this.index, this.name, this.chapters);

  Arc.fromJson(Map<String, dynamic> json)
  : name = json['name'],
    index = json['index'],
    chapters = json['chapters'] ?? List<Chapter>.empty(growable: true);
}

class Chapter {

  int index;
  String title;
  List<Paragraph> paragraphs;
  String videoUrl;
  String releaseDate;
  String duration;

  Chapter(this.index, this.title, this.paragraphs, this.videoUrl, this.duration, this.releaseDate);

  Chapter.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        title = json['title'],
        duration = json['duration'],
        releaseDate = json['releaseDate'],
        paragraphs = json['paragraphs'],
        videoUrl = json['videoUrl'];
}

class Paragraph {

  int index;
  String text;

  Paragraph(this.index, this.text);

  Paragraph.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        text = json['text'];
}

class LinkPath {

  String assetPath;
  String url;

  LinkPath(this.assetPath, this.url);

  LinkPath.from(Map<String, String> json)
    : assetPath = json['assetPath'] ?? "",
      url = json['url'] ?? "";
}

class Character {

  String name;
  String description;
  String iconUrl;
  String avatarUrl;
  String pageUrl;
  String phrase;

  Character(this.name, this.description, this.iconUrl, this.avatarUrl, this.pageUrl, this.phrase);
  Character.from(Map<String, dynamic> json) :
      name = json['name'],
      description = json['description'],
      iconUrl = json['iconUrl'],
      avatarUrl = json['avatarUrl'],
      pageUrl = json['pageUrl'],
      phrase = json['phrase'];
}