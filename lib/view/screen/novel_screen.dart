import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:xlive_switch/xlive_switch.dart';

import '../../models/novel.dart';
import '../screen/novel_image_screen.dart';
import '../widgets/chapter_card.dart';
import 'novel_see_all_screen.dart';
import '../../controller/provider/theme_provider.dart';

void novelSeeAll(BuildContext context) {
  Navigator.of(context).pushReplacementNamed(NovelSeeAllScreen.routeName);
}

class ChapterListBuilder extends StatelessWidget {
  const ChapterListBuilder({
    Key key,
    @required this.novel,
  }) : super(key: key);

  final Novel novel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: novel.chapters.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return ChapterCard(novel.chapters[index], novel);
      },
    );
  }
}

void showAsBottomSheet(BuildContext ctx, Novel novel) async {
  final result = await showSlidingBottomSheet(ctx, builder: (context) {
    return SlidingSheetDialog(
      elevation: 10,
      cornerRadius: 30,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [0.0, 0.7, 1.0],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),
      headerBuilder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(ctx).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, 10),
                  blurRadius: 12,
                  color: Colors.black12)
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Chapters',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 30, fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
        );
      },
      addTopViewPaddingOnFullscreen: true,
      builder: (context, state) {
        return novel.chapters.isNotEmpty
            ? Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.all(16),
                child: ChapterListBuilder(
                  novel: novel,
                ),
              )
            : Container(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  });
  print(result); // This is the result.
}

class NovelScreen extends StatefulWidget {
  static const routeName = '/novel-screen';

  @override
  _NovelScreenState createState() => _NovelScreenState();
}

class _NovelScreenState extends State<NovelScreen>
    with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context);
    bool check = themeData.checker;

    final novel = ModalRoute.of(context).settings.arguments as Novel;
    var size = MediaQuery.of(context).size;

    Widget myFabButton = FabButton(size: size, novel: novel, check: check);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NovelImageScreen(novel),
                    ),
                  ),
                  child: Container(
                    height: size.width + 20,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: size.width,
                          width: size.width,
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          child: Hero(
                            tag: novel.img,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              child: ShaderMask(
                                blendMode: BlendMode.darken,
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color.fromRGBO(0, 0, 0, 0.65),
                                        Color.fromRGBO(255, 255, 255, 0),
                                      ]).createShader(bounds);
                                },
                                child: Image(
                                  image: AssetImage(novel.img),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20.0,
                          bottom: 50.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                width: size.width,
                                child: Text(
                                  novel.title,
                                  maxLines: 2,
                                  style: GoogleFonts.josefinSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.2,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                novel.author,
                                style: GoogleFonts.josefinSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    letterSpacing: 2.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      child: Text(
                        'Synopsis',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.josefinSans(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Text(
                        novel.synopsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      child: Text(
                        'Translator: ${novel.translator}',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.josefinSans(
                          textStyle: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child:
            ScaleTransition(scale: _hideFabAnimController, child: myFabButton),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class FabButton extends StatelessWidget {
  const FabButton({
    Key key,
    @required this.size,
    @required this.novel,
    @required this.check,
  }) : super(key: key);

  final Size size;
  final Novel novel;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                tooltip: 'Chapters',
                onPressed: () => showAsBottomSheet(context, novel),
                icon: FaIcon(FontAwesomeIcons.alignJustify),
                color: Colors.white,
              ),
            ),
            Container(
              width: size.width / 6,
              child: IconButton(
                tooltip: 'All Novels',
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
  }
}
