import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/font_provider.dart';

class FontSettingsScreen extends StatefulWidget {
  @override
  _FontSettingsScreenState createState() => _FontSettingsScreenState();
}

class _FontSettingsScreenState extends State<FontSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FontProvider>(context);
    final fontSize = data.fontSize;
    final fontFamily = data.fontFamily;
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          right: 50,
                          left: 50,
                          bottom: 100,
                        ),
                        child: Text(
                          'Font Settings',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 45,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Font Family:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                            ),
                          ),
                          Spacer(),
                          DropdownButton(
                            value: fontFamily,
                            elevation: 16,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (ff) {
                              Provider.of<FontProvider>(
                                context,
                                listen: false,
                              ).changeFontFamily(ff);
                            },
                            items: <String>['Lato', 'NotoSerif']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Font Size:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Lato',
                            ),
                          ),
                          Spacer(),
                          DropdownButton(
                            value: fontSize,
                            elevation: 16,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(),
                            dropdownColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            onChanged: (size) {
                              Provider.of<FontProvider>(
                                context,
                                listen: false,
                              ).changeFontSize(size);
                            },
                            items: <double>[
                              11,
                              13,
                              15,
                              17,
                              19,
                              21,
                              23,
                              25,
                            ].map<DropdownMenuItem<double>>((double value) {
                              return DropdownMenuItem<double>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pop(),
          label: Text(
            'Go back',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
