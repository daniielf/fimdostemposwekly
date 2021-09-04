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

  Chapter(this.index, this.title, this.paragraphs,  this.videoUrl);

  Chapter.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        title = json['title'],
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