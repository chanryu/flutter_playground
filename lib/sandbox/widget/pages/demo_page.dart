import 'package:flutter/material.dart';

class DemoPageArguments {
  final String title;
  DemoPageArguments({@required this.title});
}

abstract class DemoPage extends StatelessWidget {
  final bool automaticallyImplyAppBar;

  DemoPage({Key key, this.automaticallyImplyAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBarIfNeeded(context),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context);

  AppBar _createAppBarIfNeeded(BuildContext context) {
    if (automaticallyImplyAppBar) {
      final DemoPageArguments arguments =
          ModalRoute.of(context).settings.arguments;
      return AppBar(title: Text(arguments.title));
    }
    return null;
  }
}
