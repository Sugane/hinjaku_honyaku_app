import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/novel_screen.dart';
import '../../models/novel.dart';

void clickCard(BuildContext ctx, Novel novel) {
  Navigator.of(ctx).pushNamed(NovelScreen.routeName, arguments: novel);
  // Provider.of<ChaptersProvider>(
  //   ctx,
  //   listen: false,
  // ).fetchChapters(novel.parent, novel.slug);
  // Provider.of<ChaptersProvider>(
  //   ctx,
  //   listen: false,
  // ).fetchChaptersQuicker();
}

class NovelCard extends StatelessWidget {
  final Novel novel;

  NovelCard(this.novel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => clickCard(context, novel),
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: 210.0,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              bottom: 10.0,
              child: Container(
                height: 140,
                width: 200.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(0, 104, 189, 1),
                      Color.fromRGBO(0, 55, 99, 1),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        novel.genre,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 3.0,
                          top: 8,
                        ),
                        child: Text(
                          'Translator: ${novel.translator}',
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: novel.img,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: ShaderMask(
                        blendMode: BlendMode.darken,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color.fromRGBO(0, 0, 0, 1.0),
                                Color.fromRGBO(255, 255, 255, 0),
                              ]).createShader(bounds);
                        },
                        child: Image(
                          height: 180.0,
                          width: 180.0,
                          fit: BoxFit.cover,
                          image: AssetImage(novel.img),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          width: 180,
                          child: Text(
                            novel.title,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.josefinSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
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
                              fontSize: 15,
                              letterSpacing: 2.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
