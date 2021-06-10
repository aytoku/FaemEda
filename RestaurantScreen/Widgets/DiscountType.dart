import 'package:flutter/material.dart';

class DiscountTapeWidget extends StatelessWidget {
  final double price;
  final oldPrice;

  DiscountTapeWidget({this.price, this.oldPrice}) ;

  @override
  Widget build(BuildContext context) {
    var discount = 100 - ((price * 100) / oldPrice);
    discount = (discount.isInfinite) ? 0 : discount.round();
    return ClipPath(
      clipper: LinePathClass(),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: Transform(
          transform: Matrix4.translationValues(17, 32 , 0),
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(35 / 360),
            child: Text(
              "-$discount%",
              style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class LinePathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    // path.quadraticBezierTo(size.width, size.height, size.width, size.height);
    path.lineTo(size.width, size.height - 32);
    path.lineTo(size.width, 40);
    path.lineTo(size.width - 60, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}