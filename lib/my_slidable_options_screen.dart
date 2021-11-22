import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'my_horizontal_list_view.dart';
import 'my_vertical_list_view.dart';

class MySlidableOptions extends StatefulWidget {
  @override
  _MySlidableOptionsState createState() => _MySlidableOptionsState();
}

class _MySlidableOptionsState extends State<MySlidableOptions> {
  SlidableController slidableController;
  List<String> listItems = [
    'SlidableScrollActionPane List',
    'SlidableDrawerActionPane List',
    'SlidableStrechActionPane List',
    'SlidableBehindActionPane List',
    'SlidableScrollActionPane Delegate',
    'SlidableDrawerActionPane Delegate',
    'SlidableStrechActionPane Delegate',
    'SlidableBehindActionPane Delegate'
  ];

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: slideAnimationChanged,
      onSlideIsOpenChanged: slideIsOpenChanged,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Slidable Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => buildList(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, Axis direction) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          height: 2,
        );
      },
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
            direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        if (index < 4) {
          return slidableWithLists(context, index, slidableDirection);
        } else {
          return slidableWithDelegates(context, index, slidableDirection);
        }
      },
      itemCount: listItems.length,
    );
  }

  Widget slidableWithLists(BuildContext context, int index, Axis direction) {
    return Slidable(
      key: Key(listItems[index]),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          showSnackBar(context,
              actionType == SlideActionType.primary ? 'Archived' : 'Deleted');
          setState(() {
            listItems.removeAt(index);
          });
        },
      ),
      actionPane: actionPane(index),
      actionExtentRatio: 0.20,
      child: direction == Axis.horizontal
          ? MyVerticalListView(listItems[index])
          : MyHorizontalListView(listItems[index]),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => showSnackBar(context, 'Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => showSnackBar(context, 'Share'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.grey.shade200,
          icon: Icons.more_horiz,
          onTap: () => showSnackBar(context, 'More'),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => showSnackBar(context, 'Delete'),
        ),
      ],
    );
  }

  Widget slidableWithDelegates( BuildContext context, int index, Axis direction) {
    return Slidable.builder(
      key: Key(listItems[index]),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        closeOnCanceled: true,
        onWillDismiss: (index != 3)
            ? null
            : (actionType) {
                return showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Delete',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      content: Text(
                        'Item will be deleted',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        FlatButton(
                          child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                );
              },
        onDismissed: (actionType) {
          showSnackBar(context,
              actionType == SlideActionType.primary ? 'Archived' : 'Deleted');
          setState(() {
            listItems.removeAt(index);
          });
        },
      ),
      actionPane: actionPane(index),
      actionExtentRatio: 0.20,
      child: direction == Axis.horizontal
          ? MyVerticalListView(listItems[index])
          : MyHorizontalListView(listItems[index]),
      actionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return IconSlideAction(
                caption: 'Archive',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.blue.withOpacity(animation.value)
                    : (renderingMode == SlidableRenderingMode.dismiss
                        ? Colors.blue
                        : Colors.green),
                icon: Icons.archive,
                onTap: () async {
                  var state = Slidable.of(context);
                  var dismiss = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        content: Text(
                          'Item will be deleted',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (dismiss) {
                    state.dismiss();
                  }
                },
              );
            } else {
              return IconSlideAction(
                caption: 'Share',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.indigo.withOpacity(animation.value)
                    : Colors.indigo,
                icon: Icons.share,
                onTap: () => showSnackBar(context, 'Share'),
              );
            }
          }),
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return IconSlideAction(
                caption: 'More',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.grey.shade200.withOpacity(animation.value)
                    : Colors.grey.shade200,
                icon: Icons.more_horiz,
                onTap: () => showSnackBar(context, 'More'),
                closeOnTap: false,
              );
            } else {
              return IconSlideAction(
                caption: 'Delete',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.red.withOpacity(animation.value)
                    : Colors.red,
                icon: Icons.delete,
                onTap: () => showSnackBar(context, 'Delete'),
              );
            }
          }),
    );
  }

  static Widget actionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableScrollActionPane();
      case 1:
        return SlidableDrawerActionPane();
      case 2:
        return SlidableStrechActionPane();
      case 3:
        return SlidableBehindActionPane();

      default:
        return null;
    }
  }

  void showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void slideAnimationChanged(Animation<double> slideAnimation) {}

  void slideIsOpenChanged(bool isOpen) {}
}
