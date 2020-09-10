import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xlive_switch/xlive_switch.dart';

import '../widgets/post_card.dart';
import 'novel_screen.dart';
import '../../controller/provider/posts_provider.dart';
import '../../controller/provider/theme_provider.dart';

class PostSeeAllScreen extends StatefulWidget {
  static const routeName = '/post-see-all-screen';

  @override
  _PostSeeAllScreenState createState() => _PostSeeAllScreenState();
}

class _PostSeeAllScreenState extends State<PostSeeAllScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;
  bool _isLoading = false;

  ScrollController _scrollController;
  AnimationController _hideFabAnimController;

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );

    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PostsProvider>(context).fetchAllPosts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _loadMore() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Loading older posts below...',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        });
    Provider.of<PostsProvider>(context, listen: false)
        .loadMorePosts()
        .then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context);
    bool check = themeData.checker;
    final size = MediaQuery.of(context).size;
    Widget myFabButton = Container(
      width: size.width / 1.5,
      height: 45.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(255, 168, 0, 1),
            Colors.orange[900],
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 3.0),
            blurRadius: 13.0,
          )
        ],
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        highlightColor: Colors.transparent,
        splashColor: Color.fromRGBO(255, 168, 0, 1),
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: size.width / 6,
              child: IconButton(
                tooltip: 'Go back',
                onPressed: () => Navigator.pop(context),
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
                color: Colors.white,
              ),
            ),
            Container(
              width: size.width / 6,
              child: IconButton(
                tooltip: 'Load more posts',
                onPressed: () => setState(() {
                  _isLoading = true;
                  print('reloading');
                  Provider.of<PostsProvider>(context, listen: false)
                      .fetchAllPosts()
                      .then((_) => setState(() {
                            _isLoading = false;
                          }));
                }),
                icon: FaIcon(FontAwesomeIcons.redo),
                color: Colors.white,
              ),
            ),
            Container(
              width: size.width / 6,
              child: IconButton(
                tooltip: 'All novels',
                onPressed: () => novelSeeAll(context),
                icon: FaIcon(FontAwesomeIcons.book),
                color: Colors.white,
              ),
            ),
            Container(
              width: size.width / 6,
              child: XlivSwitch(
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .changeTheme();
                },
                value: check,
                unActiveColor: Colors.amber,
                activeColor: Colors.indigo[900],
              ),
            )
          ],
        ),
        onPressed: () {},
      ),
    );

    final postData = Provider.of<PostsProvider>(context);
    final post = postData.allPosts;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            expandedHeight: 100,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'All Posts',
                style: GoogleFonts.josefinSans(
                  textStyle: TextStyle(
                    color: check
                        ? Color.fromRGBO(0, 140, 222, 1)
                        : Color.fromRGBO(0, 85, 155, 1),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? SliverPadding(
                  padding: EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    ]),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return PostCard(post[index]);
                      },
                      childCount: post.length,
                    ),
                  ),
                ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 100,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                RaisedButton(
                  color: Color.fromRGBO(255, 168, 0, 1),
                  textColor: Colors.white,
                  textTheme: ButtonTextTheme.normal,
                  onPressed: _loadMore,
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    'LOAD MORE',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child: ScaleTransition(
          scale: _hideFabAnimController,
          child: myFabButton,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
