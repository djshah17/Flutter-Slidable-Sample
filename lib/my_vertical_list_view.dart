import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyVerticalListView extends StatelessWidget {
  MyVerticalListView(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(title, style: TextStyle(fontSize: 22),),
        ),
      ),
    );
  }
}