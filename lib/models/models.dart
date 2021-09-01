class Act {

  int index;
  String name;
  List<Chapter> chapters = List<Chapter>.empty(growable: true);

  Act(this.index, this.name, this.chapters);

  Act.fromJson(Map<String, dynamic> json)
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