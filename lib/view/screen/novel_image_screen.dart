import 'package:flutter/material.dart';
import 'package:hinjaku_honyaku_app/models/novel.dart';

class NovelImageScreen extends StatelessWidget {
  final Novel novel;

  NovelImageScreen(this.novel);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: size.width,
        width: size.width,
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Hero(
          tag: novel.img,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: ShaderMask(
              blendMode: BlendMode.darken,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.65),
                      Color.fromRGBO(255, 255, 255, 0),
                    ]).createShader(bounds);
              },
              child: Image(
                image: AssetImage(novel.img),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
