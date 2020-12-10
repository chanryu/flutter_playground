import 'package:flutter/material.dart';

import 'demo_page.dart';

class DraggableScrollableSheetPage extends DemoPage {
  @override
  Widget buildBody(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Stack(
        children: [
          MainContent(),
          MyDraggableScrollableSheet(),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        for (var i = 0; i < 4; ++i)
          Container(
            color: Colors.orangeAccent,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: EdgeInsets.all(6),
            child: Text(
              "test " * 20 * (i + 1),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class MyDraggableScrollableSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (BuildContext context, ScrollController scrollController) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.only(top: 4, left: 4, right: 4),
          child: Column(
            children: [
              GripBar(scrollController: scrollController),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(12, 10, 10, 4),
                      child: Text('Item #$index'),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(indent: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GripBar extends StatelessWidget {
  static const double kTopMargin = 6;
  static const double kBottomMargin = 2;

  GripBar({
    this.width = 60,
    this.height = 5,
    this.color = Colors.black26,
    @required this.scrollController,
  });

  final double width;
  final double height;
  final Color color;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + kTopMargin + kBottomMargin,
      child: Stack(
        children: [
          // This is the shape of grip
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(height / 2)),
              ),
              width: width,
              margin: EdgeInsets.only(top: kTopMargin, bottom: kBottomMargin),
            ),
          ),

          // To make GripBar grippable, we need a ListView to pass in
          // DraggableScrollableSheet's scrollController.
          // This should be placed at the bottom of the children list so that
          // the whole area is grippable.
          ListView(controller: scrollController),
        ],
      ),
    );
  }
}
