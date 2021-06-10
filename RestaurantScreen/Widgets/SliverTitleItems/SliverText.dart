 import 'package:flutter/material.dart';

class SliverText extends StatefulWidget {
  SliverText({
    this.key,
    this.title
  }) : super(key: key);
  final GlobalKey<SliverTextState> key;
  Text title;

  @override
  SliverTextState createState() {
    return new SliverTextState(title);
  }
}

class SliverTextState extends State<SliverText>{

  Text title;
  SliverTextState(title);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: title
    );
  }
}