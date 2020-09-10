import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/provider/font_provider.dart';
import '../widgets/posts_widget.dart';
import '../widgets/novels_widget.dart';
import '../../controller/provider/chapters_provider.dart';
import '../../controller/provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (message) {
        final snackBar = SnackBar(
          content: Text('There\'s a new post!'),
          action: SnackBarAction(
            label: 'Posts',
            onPressed: () => postSeeAll(context),
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isLoaded == false) {
      Provider.of<FontProvider>(context).loadFontFamilyPref();
      Provider.of<FontProvider>(context).loadFontSizePref();
      Provider.of<ChaptersProvider>(context).fetchChaptersQuicker();
    }
    _isLoaded = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ThemeProvider>(context);
    final check = data.checker;
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 8.0,
                  ),
                  child: check
                      ? Image.asset(
                          'images/HHWhite.png',
                        )
                      : Image.asset(
                          'images/HHBlack.png',
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              NovelsWidget(),
              SizedBox(
                height: 20,
              ),
              PostsWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        heroTag: 'fabhero',
        backgroundColor: Color.fromRGBO(255, 168, 0, 1),
        child: FaIcon(
          FontAwesomeIcons.heart,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        overlayColor: Colors.black12,
        overlayOpacity: 0.5,
        tooltip: 'Support Us',
        children: [
          SpeedDialChild(
            child: Center(
                child: FaIcon(
              FontAwesomeIcons.patreon,
              color: Theme.of(context).scaffoldBackgroundColor,
            )),
            backgroundColor: Colors.orange[900],
            label: 'Patreon',
            labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 10,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: () => _launchURL('https://www.patreon.com/hinjakuhonyaku'),
          ),
          SpeedDialChild(
            child: Center(
                child: FaIcon(
              FontAwesomeIcons.discord,
              color: Theme.of(context).scaffoldBackgroundColor,
            )),
            backgroundColor: Colors.indigo[700],
            label: 'Discord',
            labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: () => _launchURL('https://discord.gg/4DV2cNP'),
          ),
          SpeedDialChild(
            child: Center(
                child: FaIcon(
              FontAwesomeIcons.facebookF,
              color: Theme.of(context).scaffoldBackgroundColor,
            )),
            label: 'Facebook',
            labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: Colors.blue[500],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: () => _launchURL('https://www.facebook.com/hinjakuhonyaku'),
          ),
          SpeedDialChild(
            child: Center(
              child: FaIcon(FontAwesomeIcons.twitter,
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
            label: 'Twitter',
            labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: Colors.blue[300],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: () => _launchURL('https://twitter.com/hinjakuhonyaku'),
          ),
          SpeedDialChild(
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.googlePlay,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            labelBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            label: 'Rate Us On PlayStore',
            backgroundColor: Colors.lightGreenAccent[700],
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
