import 'package:flutter/material.dart';

class PageViewItem extends StatefulWidget {
  final Widget child;

  const PageViewItem({Key? key, required this.child}) : super(key: key);
  @override
  DashPageViewItemState createState() => DashPageViewItemState();
}

class DashPageViewItemState extends State<PageViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // print('DashPageViewItem initState');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
