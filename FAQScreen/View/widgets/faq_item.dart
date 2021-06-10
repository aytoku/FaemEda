import 'package:expandable_widget/res/expandable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final EdgeInsets padding;

  const FaqItem({
    this.question = '',
    this.answer = '',
    this.padding = EdgeInsets.zero,
    Key key,
  }) : super(key: key);

  @override
  _FaqItemState createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with TickerProviderStateMixin {
  bool _showManual = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.question,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF404040),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _showManual = !_showManual),
                iconSize: 20,
                constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                splashRadius: 20,
                icon: SvgPicture.asset(
                  (!_showManual) ? 'assets/svg_images/plus_counter.svg' : 'assets/svg_images/big_cross.svg',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          ExpandableWidget.manual(
            expand: _showManual,
            vsync: this,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 3, top: 3),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9A9A9A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13),
            child: Divider(height: 0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
