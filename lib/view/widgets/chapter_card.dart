import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/chapter.dart';
import '../../models/novel.dart';
import '../screen/chapter_screen.dart';

// void clickChapter(BuildContext ctx, Chapter chapter, Novel novel) {
//   Navigator.push(
//       ctx,
//       MaterialPageRoute(
//           builder: (ctx) => ChapterScreen(chapter: chapter, novel: novel)));
// }

class ChapterCard extends StatelessWidget {
  final Novel novel;
  final Chapter chapter;

  ChapterCard(this.chapter, this.novel);

  @override
  Widget build(BuildContext context) {
    return ChapterCardContainer(chapter, novel);
  }
}

class ChapterCardContainer extends StatelessWidget {
  final Chapter chapter;
  final Novel novel;

  ChapterCardContainer(this.chapter, this.novel);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      width: size.width - 40,
      height: 80,
      child: Card(
        size: size,
        chapter: chapter,
        novel: novel,
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key key,
    @required this.size,
    @required this.chapter,
    @required this.novel,
  }) : super(key: key);

  final Size size;
  final Chapter chapter;
  final ContainerTransitionType transType = ContainerTransitionType.fade;
  final Novel novel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OpenContainer(
        closedColor: Theme.of(context).scaffoldBackgroundColor,
        closedElevation: 8,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        openShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        transitionType: transType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return ChapterScreen(
            chapter: chapter,
            novel: novel,
          );
        },
        transitionDuration: Duration(milliseconds: 700),
        openElevation: 10,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Container(
            height: 60,
            width: size.width - 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange[600],
                  Colors.orange[900],
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 3.0),
                  blurRadius: 15.0,
                )
              ],
            ),
            child: Material(
              animationDuration: Duration(milliseconds: 200),
              type: MaterialType.transparency,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: openContainer,
                focusColor: Colors.blue,
                splashColor: Colors.orange[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Chapter ${chapter.id}',
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.readme),
                        color: Colors.white,
                        onPressed: openContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
