import 'package:flutter/material.dart';

import 'demo_page.dart';

class SnackBarPage extends DemoPage {
  @override
  Widget buildBody(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              child: Text("Like"),
              onPressed: () => showSnackBar(context, true),
            ),
            SizedBox(width: 10),
            RaisedButton(
              child: Text("Hate"),
              onPressed: () => showSnackBar(context, false),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, bool like) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(like ? Icons.thumb_up : Icons.thumb_down),
            SizedBox(width: 10),
            Expanded(child: Text(like ? "Yay!" : "Boo!")),
          ],
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
