import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/posts.dart';
import '../screen/post_screen.dart';

class PostCard extends StatelessWidget {
  final Posts post;

  PostCard(this.post);

  String removeUnicodeApostrophes(String str) {
    String modifiedStr = str.replaceAll('&#8217;', '\'');
    return modifiedStr;
  }

  // void clickCard(BuildContext ctx, Posts post) {
  //   Navigator.of(ctx).pushNamed(PostScreen.routeName, arguments: post);
  // }

  @override
  Widget build(BuildContext context) {
    return PostCardContainer(post);
  }
}

class PostCardContainer extends StatelessWidget {
  final Posts post;

  PostCardContainer(this.post);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(post.date);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      width: double.infinity,
      height: 130,
      child: Card(post: post, parsedDate: parsedDate),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
    Key key,
    @required this.post,
    @required this.parsedDate,
  }) : super(key: key);

  final DateTime parsedDate;
  final Posts post;
  final ContainerTransitionType transType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        OpenContainer(
            transitionType: transType,
            openBuilder: (BuildContext context, VoidCallback _) {
              return PostScreen(post);
            },
            closedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            openShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            closedColor: Theme.of(context).scaffoldBackgroundColor,
            closedElevation: 10,
            transitionDuration: Duration(milliseconds: 700),
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return Container(
                child: Material(
                  animationDuration: Duration(milliseconds: 200),
                  type: MaterialType.transparency,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: openContainer,
                    focusColor: Colors.blue,
                    splashColor: Color.fromRGBO(109, 21, 155, 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 10,
                          ),
                          child: Text(
                            removeUnicodeApostrophes(post.title),
                            style: GoogleFonts.dosis(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                bottom: 15,
                              ),
                              child: Text(
                                post.author,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                bottom: 15,
                              ),
                              child: Text(
                                DateFormat.yMMMd().format(parsedDate),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(109, 21, 155, 1),
                      Color.fromRGBO(58, 3, 87, 1),
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
              );
            }),
      ],
    );
  }
}
