class NoteData {
  String title;
  String note;
  String noteId;
  String videoLink;

  NoteData(
      {this.title, this.note, this.noteId, this.videoLink = "no_video_link"});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['noteTitle'] = title;
    map['noteData'] = note;
    map['noteVideoLink'] = videoLink;

    return map;
  }

  NoteData.fromMapObject(Map<String, dynamic> map) {
    this.title = map['noteTitle'];
    this.note = map['noteData'];
    this.videoLink = map['noteVideoLink'];
  }
}
