import 'package:flutter/material.dart';

import 'pages/animated_icon_page.dart';
import 'pages/demo_page.dart';
import 'pages/draggable_scrollable_sheet_page.dart';
import 'pages/hero_page.dart';
import 'pages/modal_route_page.dart';
import 'pages/sliver_app_bar_page.dart';
import 'pages/snack_bar_page.dart';

class _DemoPageRoute extends MaterialPageRoute<void> {
  final String title;
  final String subtitle;

  _DemoPageRoute({
    @required this.title,
    this.subtitle,
    @required WidgetBuilder pageBuilder,
  }) : super(
          builder: pageBuilder,
          settings: RouteSettings(
            arguments: DemoPageArguments(title: title),
          ),
        );
}

final List<_DemoPageRoute> _kDemoPageRoutes = [
  _DemoPageRoute(
    title: 'AnimatedIcon',
    subtitle: 'AnimatedIcons, GridView, Card, etc.',
    pageBuilder: (context) => AnimatedIconPage(),
  ),
  _DemoPageRoute(
    title: 'SliverAppBar',
    subtitle: 'CustomScrollView, SliverAppBar, SliverFillRemaining, etc.',
    pageBuilder: (context) => SliverAppBarPage(),
  ),
  _DemoPageRoute(
    title: 'SnackBar',
    subtitle: 'SnackBar, Builder, ...',
    pageBuilder: (context) => SnackBarPage(),
  ),
  _DemoPageRoute(
    title: 'DraggableScrollableSheet',
    pageBuilder: (context) => DraggableScrollableSheetPage(),
  ),
  _DemoPageRoute(
    title: 'Hero',
    pageBuilder: (context) => HeroPage(),
  ),
  _DemoPageRoute(
    title: 'ModalRoute',
    pageBuilder: (context) => ModalRoutePage(),
  ),
];

Text _stringToText(String str) => str == null ? null : Text(str);

class WidgetSandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Sandbox'),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: _kDemoPageRoutes.length,
          itemBuilder: (_, index) {
            final pageRoute = _kDemoPageRoutes[index];
            return ListTile(
                title: Text(pageRoute.title),
                subtitle: _stringToText(pageRoute.subtitle),
                trailing: Icon(Icons.navigate_next_rounded),
                onTap: () {
                  Navigator.push(context, pageRoute);
                });
          },
          separatorBuilder: (_, __) => Divider(),
        ),
      ),
    );
  }
}
