import 'package:flutter/material.dart';

class MyHorizontalListView extends StatelessWidget {
  MyHorizontalListView(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}