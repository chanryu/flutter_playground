import 'package:flutter/material.dart';

import 'pages/animated_icon_page.dart';
import 'pages/demo_page.dart';
import 'pages/draggable_scrollable_sheet_page.dart';
import 'pages/hero_page.dart';
import 'pages/modal_route_page.dart';
import 'pages/sliver_app_bar_page.dart';
import 'pages/snack_bar_page.dart';

class _Page {
  final String title;
  final String subtitle;
  final String routeName;
  final WidgetBuilder pageBuilder;

  const _Page({
    @required this.title,
    this.subtitle,
    @required this.routeName,
    @required this.pageBuilder,
  });
}

final List<_Page> _kPages = [
  _Page(
    title: 'AnimatedIcon',
    subtitle: 'AnimatedIcons, GridView, Card, etc.',
    routeName: '/AnimatedIconPage',
    pageBuilder: (context) => AnimatedIconPage(),
  ),
  _Page(
    title: 'SliverAppBar',
    subtitle: 'CustomScrollView, SliverAppBar, SliverFillRemaining, etc.',
    routeName: '/SliverAppBar',
    pageBuilder: (context) => SliverAppBarPage(),
  ),
  _Page(
    title: 'SnackBar',
    subtitle: 'SnackBar, Builder, ...',
    routeName: '/SnackBarPage',
    pageBuilder: (context) => SnackBarPage(),
  ),
  _Page(
    title: 'DraggableScrollableSheet',
    routeName: '/DraggableScrollableSheet',
    pageBuilder: (context) => DraggableScrollableSheetPage(),
  ),
  _Page(
    title: 'Hero',
    routeName: '/HeroPage',
    pageBuilder: (context) => HeroPage(),
  ),
  _Page(
    title: 'ModalRoute',
    routeName: '/ModalRoute',
    pageBuilder: (context) => ModalRoutePage(),
  ),
];

class WidgetSandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Sandbox'),
      ),
      body: Container(
        child: ListView.separated(
          itemCount: _kPages.length,
          itemBuilder: (_, index) {
            final page = _kPages[index];
            return ListTile(
                title: Text(page.title),
                subtitle: page.subtitle != null ? Text(page.subtitle) : null,
                trailing: Icon(Icons.navigate_next_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: page.pageBuilder,
                      settings: RouteSettings(
                        arguments: DemoPageArguments(title: page.title),
                      ),
                    ),
                  );
                });
          },
          separatorBuilder: (_, __) => Divider(),
        ),
      ),
    );
  }
}
