import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  final List<Widget> children;
  final double top;
  final double left;
  final double right;
  final double bottom;
  final String direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  Space({
    super.key,
    required this.children,
    this.direction = 'row',
    this.top = 0,
    this.left = 0,
    this.right = 0,
    this.bottom = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < children.length; i++) {
      double r = i == children.length - 1 ? 0 : right;
      double b = i == children.length - 1 ? 0 : bottom;

      if (direction == 'row') {
        list.add(
          Padding(
            padding: EdgeInsets.only(right: r, bottom: b),
            child: children[i],
          ),
        );
      } else {
        list.add(
          Padding(
            padding: EdgeInsets.only(bottom: b),
            child: children[i],
          ),
        );
      }
    }

    return direction == 'row'
        ? Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: list,
          )
        : Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: list,
          );
  }
}
