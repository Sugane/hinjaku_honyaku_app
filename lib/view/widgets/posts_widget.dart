import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'post_card.dart';
import '../../controller/provider/posts_provider.dart';
import '../screen/post_see_all_screen.dart';

class PostsWidget extends StatefulWidget {
  @override
  _PostsWidgetState createState() => _PostsWidgetState();
}

void postSeeAll(BuildContext context) {
  Navigator.of(context).pushNamed(PostSeeAllScreen.routeName);
}

class _PostsWidgetState extends State<PostsWidget> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PostsProvider>(context).fetchHomePagePosts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final postData = Provider.of<PostsProvider>(context);
    final post = postData.posts;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Latest Posts',
                  style: GoogleFonts.josefinSans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => postSeeAll(context),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFF3EBACE),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: 400,
                  child: Column(
                    children: <Widget>[
                      PostCard(post[0]),
                      PostCard(post[1]),
                      PostCard(post[2]),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
