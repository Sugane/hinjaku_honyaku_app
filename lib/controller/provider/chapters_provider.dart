import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../models/chapter.dart';
import '../../models/novel_data.dart';

class ChaptersProvider extends ChangeNotifier {
  List<Chapter> _chapters = [];

  bool _loading = true;

  List<Chapter> get chapters {
    return [..._chapters];
  }

  bool get loading {
    return _loading;
  }

  Future<void> fetchChapters(String parent, String slug) async {
    final String pagesFetch = 'https://hinjakuhonyaku.com/wp-json/wp/v2/pages?';
    final String url =
        'https://hinjakuhonyaku.com/wp-json/wp/v2/pages?parent=' + parent;
    final response = await http.get(url);
    final totalPgCount = int.parse(response.headers['x-wp-total']);
    print(totalPgCount);
    final List<Chapter> loadedData = [];
    int number = 1;
    for (int i = 0; i < totalPgCount; i++) {
      String chapterNo = 'c' + '$number';
      String chapter = pagesFetch + 'slug=' + slug + chapterNo;
      final chapterResponse = await http.get(chapter);
      final extractedData = json.decode(chapterResponse.body) as List<dynamic>;

      extractedData.asMap().forEach((chapterId, chapterValue) {
        loadedData.add(Chapter(
          id: number,
          content: chapterValue['content']['rendered'],
        ));
      });
      number = number + 1;
    }
    _chapters = loadedData;
    print(_chapters);
    novelData.firstWhere((parentId) => parent == parentId.parent).chapters =
        _chapters;
  }

  Future<void> fetchChaptersQuicker() async {
    final String fetch = 'https://hinjakuhonyaku.com/wp-json/wp/v2/pages?';

    for (int i = 0; i < novelData.length; i++) {
      final List<Chapter> loadedData = [];
      final String parent = novelData[i].parent;
      final String url = fetch +
          'parent=' +
          parent +
          '&?filter[orderby]=date&order=asc&per_page=100';
      final chapterResponse = await http.get(url);
      final extractedData = json.decode(chapterResponse.body) as List<dynamic>;

      if (parent != '465') {
        extractedData.asMap().forEach((chapterId, chapterValue) {
          loadedData.add(Chapter(
            id: chapterId + 1,
            content: chapterValue['content']['rendered'],
          ));
        });
      } else {
        extractedData.asMap().forEach((chapterId, chapterValue) {
          loadedData.add(Chapter(
            id: chapterId + 4,
            content: chapterValue['content']['rendered'],
          ));
        });
      }
      _chapters = loadedData;
      print(_chapters);
      novelData.firstWhere((parentId) => parent == parentId.parent).chapters =
          _chapters;
    }
  }
}
