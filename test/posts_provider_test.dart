import 'package:test/test.dart';
import '../lib/controller/provider/posts_provider.dart';
import '../lib/models/posts.dart';
import 'dart:async';

void main() {
  group('Unit tests for all the methods in posts provider: ', () {
    test('There should be 0 posts at start', () {
      expect(PostsProvider().posts, []);
    });

    test('Fetches 3 posts for the home page', () async {
      final postsProvider = PostsProvider();

      List<Posts> posts = await postsProvider.fetchHomePosts();

      expect(posts.length, 3);
    });

    test('Fetches 10 posts for the all posts page', () async {
      final postsProvider = PostsProvider();

      List<Posts> posts = await postsProvider.fetchTenPosts();

      expect(posts.length, 10);
    });

    test('Loads 30 more posts', () async {
      final postsProvider = PostsProvider();

      List<Posts> posts = await postsProvider.fetchTenPosts();
      posts += await postsProvider.loadThreeMorePosts();

      expect(posts.length, 40);
    });
  });
}
