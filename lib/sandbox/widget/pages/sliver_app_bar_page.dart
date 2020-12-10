import 'package:flutter/material.dart';

import 'demo_page.dart';

class SliverAppBarPage extends DemoPage {
  SliverAppBarPage() : super(automaticallyImplyAppBar: false);

  @override
  Widget buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: Image.asset(
              'assets/images/ink_cloud.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverFillRemaining(
          child: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Placeholder(),
            ),
          ),
        ),
      ],
    );
  }
}

// To keep the image when SliverAppBar is collapsed, use the following instead
// of FlexibleSpaceBar:
// Stack(
//   children: <Widget>[
//     Positioned.fill(
//       child: Image.asset("assets/images/ink_cloud.png", fit: BoxFit.cover),
//     ),
//   ],
// )
