import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xlive_switch/xlive_switch.dart';

import 'novels_widget.dart';

class ExpandedFabButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var check = useState(false);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 1.5,
      height: 45.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange[600],
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
        shape: RoundedRectangleBorder(),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        elevation: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: size.width / 6,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: FaIcon(FontAwesomeIcons.arrowLeft),
                color: Colors.black,
              ),
            ),
            Container(
              width: size.width / 6,
              child: IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.alignJustify),
                color: Colors.black,
              ),
            ),
            Container(
              width: size.width / 6,
              child: IconButton(
                onPressed: () => novelSeeAll(context),
                icon: FaIcon(FontAwesomeIcons.book),
                color: Colors.black,
              ),
            ),
            Container(
              width: size.width / 6,
              child: XlivSwitch(
                onChanged: (value) {
                  if (check.value == true) {
                    check.value = false;
                  } else {
                    check.value = true;
                  }
                },
                value: check.value,
                unActiveColor: Colors.amber,
                activeColor: Colors.indigo[900],
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }
}
