import 'dart:convert';

class ScannedDocument {

  String? text;
  ScannedDocument({this.text});

  factory ScannedDocument.fromRawJson(String str)=> ScannedDocument.fromJson(jsonDecode(str));

  String toRawJson() => jsonEncode(toJson());

  factory ScannedDocument.fromJson(Map<String,dynamic> json)=> ScannedDocument(text: json["text"]);

  Map<String,dynamic> toJson()=> {"text" : text};

}