import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import '../../controller/hooks/scroll_controller_animation.dart';
import '../../models/novel.dart';
import '../../models/posts.dart';
import '../../models/novel_data.dart';
import 'novel_screen.dart';

void goToNovelPage(BuildContext ctx, Novel novel) {
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

void tapLink(BuildContext ctx, String url) {
  String slug;
  List<String> formatUrl = url.split('/');
  if (formatUrl[formatUrl.length - 1].endsWith('0') ||
      formatUrl[formatUrl.length - 1].endsWith('1') ||
      formatUrl[formatUrl.length - 1].endsWith('2') ||
      formatUrl[formatUrl.length - 1].endsWith('3') ||
      formatUrl[formatUrl.length - 1].endsWith('4') ||
      formatUrl[formatUrl.length - 1].endsWith('5') ||
      formatUrl[formatUrl.length - 1].endsWith('6') ||
      formatUrl[formatUrl.length - 1].endsWith('7') ||
      formatUrl[formatUrl.length - 1].endsWith('8') ||
      formatUrl[formatUrl.length - 1].endsWith('9')) {
    print(formatUrl[formatUrl.length - 1]);
    slug = formatUrl[formatUrl.length - 1];
  } else if (formatUrl[formatUrl.length - 2].endsWith('0') ||
      formatUrl[formatUrl.length - 2].endsWith('1') ||
      formatUrl[formatUrl.length - 2].endsWith('2') ||
      formatUrl[formatUrl.length - 2].endsWith('3') ||
      formatUrl[formatUrl.length - 2].endsWith('4') ||
      formatUrl[formatUrl.length - 2].endsWith('5') ||
      formatUrl[formatUrl.length - 2].endsWith('6') ||
      formatUrl[formatUrl.length - 2].endsWith('7') ||
      formatUrl[formatUrl.length - 2].endsWith('8') ||
      formatUrl[formatUrl.length - 2].endsWith('9')) {
    slug = formatUrl[formatUrl.length - 2];
  } else {
    slug = formatUrl[formatUrl.length - 3];
  }

  for (int i = 0; i < novelData.length; i++) {
    if (slug.contains(novelData[i].slug)) {
      goToNovelPage(ctx, novelData[i]);
      break;
    }
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String removeUnicodeApostrophes(String str) {
  String modifiedStr = str.replaceAll('&#8217;', '\'');
  return modifiedStr;
}

class PostScreen extends HookWidget {
  final Posts post;

  PostScreen(this.post);

  static const routeName = '/post-screen';

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(post.date);
    final hideFabAnimController = useAnimationController(
        duration: kThemeAnimationDuration, initialValue: 1);
    final scrollController =
        useScrollControllerForAnimation(hideFabAnimController);
    // final post = ModalRoute.of(context).settings.arguments as Posts;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 60,
                right: 15,
                left: 15,
              ),
              child: Text(
                removeUnicodeApostrophes(post.title),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: Text(
                    post.author,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: Text(
                    DateFormat.yMMMd().format(parsedDate),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              child: ContentHtml(post: post, size: size),
            ),
          ],
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: hideFabAnimController,
        child: ScaleTransition(
          scale: hideFabAnimController,
          child: FloatingActionButton.extended(
            heroTag: 'fabhero',
            onPressed: () => Navigator.of(context).pop(),
            label: Text('Back'),
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              size: 15,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ContentHtml extends StatelessWidget {
  const ContentHtml({
    Key key,
    @required this.post,
    @required this.size,
  }) : super(key: key);

  final Posts post;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Html(
      useRichText: false,
      data: post.content,
      defaultTextStyle: const TextStyle(
        fontSize: 15,
        fontFamily: 'Lato',
      ),
      linkStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),
      onLinkTap: (url) {
        if (url.contains('hinjakuhonyaku.com')) {
          tapLink(context, url);
        } else {
          _launchURL(url);
        }
      },
      customRender: (node, children) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "div":
              return SizedBox(
                height: 20,
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
                        color: Colors.black38,
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
