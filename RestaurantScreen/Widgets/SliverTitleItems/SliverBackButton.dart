import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SliverBackButton extends StatefulWidget {
  SliverBackButton({
    this.key,
    this.image
  }) : super(key: key);
  final GlobalKey<SliverBackButtonState> key;
  SvgPicture image;

  @override
  SliverBackButtonState createState() {
    return new SliverBackButtonState(image);
  }
}

class SliverBackButtonState extends State<SliverBackButton>{


  SvgPicture image;

  SliverBackButtonState(image);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: image
    );
  }
}