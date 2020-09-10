import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:xlive_switch/xlive_switch.dart';
import 'package:delayed_display/delayed_display.dart';

import '../../models/chapter.dart';
import './font_settings_screen.dart';
import '../widgets/chapter_card.dart';
import '../../models/novel.dart';
import '../../controller/provider/font_provider.dart';
import '../../controller/provider/theme_provider.dart';

void showAsBottomSheet(BuildContext context, Novel novel) async {
  final result = await showSlidingBottomSheet(context, builder: (context) {
    return SlidingSheetDialog(
      elevation: 8,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [0.0, 0.7, 1.0],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),
      headerBuilder: (context, state) {
        return Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0.0, 12.0),
                blurRadius: 10.0,
              )
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Chapters',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      },
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

class ChapterScreen extends StatefulWidget {
  static const routeName = '/chapter-screen';

  final Chapter chapter;
  final Novel novel;

  ChapterScreen({@required this.chapter, this.novel});

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _hideFabAnimController;
  bool load = true;

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
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        load = false;
      });
    });

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
    final fontData = Provider.of<FontProvider>(context);
    final fontSize = fontData.fontSize;
    final fontFamily = fontData.fontFamily;
    final size = MediaQuery.of(context).size;
    final themeData = Provider.of<ThemeProvider>(context);
    bool check = themeData.checker;
    Widget myFabButton =
        FabButton(size: size, novel: widget.novel, check: check);

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: load
              ? Container(
                  height: size.height - 50,
                  width: size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  slidingBeginOffset: Offset(0, 0),
                  fadingDuration: Duration(milliseconds: 800),
                  slidingCurve: Curves.easeIn,
                  child: ContentHtml(
                      fontFamily: fontFamily,
                      fontSize: fontSize,
                      chapter: widget.chapter,
                      size: size,
                      check: check),
                ),
        ),
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
                tooltip: 'Font settings',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FontSettingsScreen())),
                icon: FaIcon(FontAwesomeIcons.slidersH),
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

class ContentHtml extends StatelessWidget {
  const ContentHtml({
    Key key,
    @required this.fontFamily,
    @required this.fontSize,
    @required this.chapter,
    @required this.size,
    @required this.check,
  }) : super(key: key);

  final String fontFamily;
  final double fontSize;
  final Chapter chapter;
  final Size size;
  final bool check;

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      defaultTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            fontFamily: fontFamily,
            letterSpacing: 0.6,
            fontSize: fontSize,
          ),
      customTextStyle: (dom.Node node, TextStyle baseStyle) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "h1":
              return baseStyle.merge(
                TextStyle(
                    fontSize: 30,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w900),
              );
          }
        }
        return baseStyle;
      },
      useRichText: false,
      data: chapter.content,
      customRender: (node, children) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "div":
              return SizedBox(
                height: 100,
              );
            case "h1":
              return Align(
                alignment: Alignment.center,
                child: Text(
                  node.innerHtml
                      .replaceAll('<strong>', '')
                      .replaceAll('</strong>', '')
                      .replaceAll('<br>', '')
                      .replaceAll('<em>', '')
                      .replaceAll('</em>', ''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w900),
                ),
              );
            case "hr":
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 3,
                      width: size.width - 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: check ? Colors.white : Colors.black38,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
          }
        }
      },
    );
  }
}
