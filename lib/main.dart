import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controller/provider/font_provider.dart';
import 'package:provider/provider.dart';

import 'view/screen/novel_screen.dart';
import 'view/screen/novel_see_all_screen.dart';
import 'view/screen/home_screen.dart';
import 'view/screen/post_see_all_screen.dart';

import 'controller/provider/posts_provider.dart';
import 'controller/provider/chapters_provider.dart';
import 'controller/provider/theme_provider.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final josefinLicense = await rootBundle
        .loadString('google_fonts/font_licenses/JosefinOFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], josefinLicense);
    final latoLicense =
        await rootBundle.loadString('google_fonts/font_licenses/LatoOFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], latoLicense);
    final loraLicense =
        await rootBundle.loadString('google_fonts/font_licenses/LoraOFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], loraLicense);
    final dosisLicense =
        await rootBundle.loadString('google_fonts/font_licenses/DosisOFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], dosisLicense);
    final notoLicense =
        await rootBundle.loadString('google_fonts/font_licenses/NotoOFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], notoLicense);
  });
  runApp(ChangeNotifierProvider(
    create: (ctx) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (_isLoaded == false) {
      Provider.of<ThemeProvider>(context).loadTheme();
    }
    setState(() {
      _isLoaded = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => PostsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ChaptersProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FontProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hinjaku Honyaku',
        theme: Provider.of<ThemeProvider>(context).theme,
        routes: {
          '/': (ctx) => HomeScreen(),
          NovelScreen.routeName: (ctx) => NovelScreen(),
          NovelSeeAllScreen.routeName: (ctx) => NovelSeeAllScreen(),
          PostSeeAllScreen.routeName: (ctx) => PostSeeAllScreen(),
          //PostScreen.routeName: (ctx) => PostScreen(),
        },
      ),
    );
  }
}
