import 'package:flutter/foundation.dart';

import 'chapter.dart';

class Novel {
  final int id;
  final String slug;
  final String title;
  final String synopsis;
  final String img;
  final String translator;
  final String author;
  final String genre;
  final String parent;
  List<Chapter> chapters;

  Novel({
    @required this.id,
    @required this.author,
    @required this.img,
    @required this.slug,
    @required this.synopsis,
    @required this.title,
    @required this.translator,
    @required this.genre,
    @required this.parent,
    @required this.chapters,
  });
}
