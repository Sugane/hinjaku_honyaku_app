import 'package:flutter/foundation.dart';

class Posts {
  final String title;
  final int id;
  final String author;
  final String date;
  final String content;

  Posts({
    @required this.title,
    @required this.id,
    @required this.author,
    @required this.date,
    @required this.content,
  });
}
