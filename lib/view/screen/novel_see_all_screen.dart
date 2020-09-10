import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../models/novel.dart';
import '../../models/novel_data.dart';
import '../../controller/provider/theme_provider.dart';
import 'home_screen.dart';
import 'novel_screen.dart';

class NovelSeeAllScreen extends StatelessWidget {
  static const routeName = '/novel-see-all-screen';

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeProvider>(context);
    bool check = themeData.checker;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Container(),
            expandedHeight: 100,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Novels',
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
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              childAspectRatio: 1 / 2,
              children: <Widget>[
                NovelLargeCard(novelData[0]),
                NovelLargeCard(novelData[1]),
                NovelLargeCard(novelData[2]),
                NovelLargeCard(novelData[3]),
                NovelLargeCard(novelData[4]),
                NovelLargeCard(novelData[5]),
                NovelLargeCard(novelData[6]),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fabhero',
        splashColor: Color.fromRGBO(255, 168, 0, 1),
        onPressed: () => homeScreen(context),
        label: Text('Home'),
        icon: FaIcon(
          FontAwesomeIcons.home,
          size: 15,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

void homeScreen(BuildContext ctx) {
  Navigator.pushReplacement(
      ctx, MaterialPageRoute(builder: (ctx) => HomeScreen()));
}

void clickCard(BuildContext ctx, Novel novel) {
  Navigator.of(ctx)
      .pushReplacementNamed(NovelScreen.routeName, arguments: novel);
  // Provider.of<ChaptersProvider>(
  //   ctx,
  //   listen: false,
  // ).fetchChapters(novel.parent, novel.slug);
  // Provider.of<ChaptersProvider>(
  //   ctx,
  //   listen: false,
  // ).fetchChaptersQuicker();
}

class NovelLargeCard extends StatelessWidget {
  final Novel novel;

  NovelLargeCard(this.novel);

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
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2.0, 3.0),
                    blurRadius: 8.0,
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
                                Color.fromRGBO(0, 0, 0, 0.85),
                                Color.fromRGBO(255, 255, 255, 0),
                              ]).createShader(bounds);
                        },
                        child: Image(
                          height: 400,
                          width: 220.0,
                          fit: BoxFit.cover,
                          image: AssetImage(novel.img),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 20.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          width: 180,
                          child: Text(
                            novel.title,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.josefinSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
