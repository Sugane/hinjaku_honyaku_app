import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hinjaku_honyaku_app/models/chapter.dart';
import 'package:http/http.dart' as http;

import '../../models/posts.dart';
import '../../models/author.dart';

class PostsProvider extends ChangeNotifier {
  int page = 2;

  List<Posts> _homePosts = [];
  List<Posts> _allPosts = [];

  List<Posts> get posts {
    return [..._homePosts];
  }

  List<Posts> get allPosts {
    return [..._allPosts];
  }

  Future<void> fetchHomePagePosts() async {
    const String url =
        'https://hinjakuhonyaku.com/wp-json/wp/v2/posts?per_page=3';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as List<dynamic>;
    final List<Posts> loadedData = [];
    extractedData.asMap().forEach((postId, postValue) {
      loadedData.add(Posts(
        id: postId,
        title: postValue['title']['rendered'],
        author: author(postValue['author']),
        date: postValue['date'],
        content: postValue['content']['rendered'],
      ));
    });
    _homePosts = loadedData;
    notifyListeners();
  }

  Future<void> fetchAllPosts() async {
    const String url = 'https://hinjakuhonyaku.com/wp-json/wp/v2/posts';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as List<dynamic>;
    final List<Posts> loadedData = [];
    extractedData.asMap().forEach((postId, postValue) {
      loadedData.add(Posts(
        id: postId,
        title: postValue['title']['rendered'],
        author: author(postValue['author']),
        date: postValue['date'],
        content: postValue['content']['rendered'],
      ));
    });
    _allPosts = loadedData;
    print(_allPosts);
    notifyListeners();
  }

  Future<void> loadMorePosts() async {
    String url =
        'https://hinjakuhonyaku.com/wp-json/wp/v2/posts?page=' + '$page';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as List<dynamic>;
    final List<Posts> loadedData = [];
    extractedData.asMap().forEach((postId, postValue) {
      loadedData.add(Posts(
        id: postId,
        title: postValue['title']['rendered'],
        author: author(postValue['author']),
        date: postValue['date'],
        content: postValue['content']['rendered'],
      ));
    });
    _allPosts.addAll(loadedData);
    print('loading more');
    page++;
    notifyListeners();
  }

  Future<void> linkTap(String url) async {
    String api = 'https://hinjakuhonyaku.com/wp-json/wp/v2/pages?slug=';
    final response = await http.get(api);
    final extractedData = json.decode(response.body) as List<dynamic>;
    return Chapter(
        id: extractedData[0]['id'],
        content: extractedData[0]['content']['rendered']);
  }
}
