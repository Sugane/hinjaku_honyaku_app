import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/novel_see_all_screen.dart';
import '../../models/novel_data.dart';
import 'novel_card.dart';

void novelSeeAll(BuildContext context) {
  Navigator.of(context).pushNamed(NovelSeeAllScreen.routeName);
}

class NovelsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Novels',
                style: GoogleFonts.josefinSans(
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.5,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => novelSeeAll(context),
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
        Container(
          height: 310,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              NovelCard(novelData[0]),
              NovelCard(novelData[1]),
              NovelCard(novelData[2]),
              NovelCard(novelData[3]),
              NovelCard(novelData[4]),
              NovelCard(novelData[5]),
              NovelCard(novelData[6]),
            ],
          ),
        ),
      ],
    );
  }
}
