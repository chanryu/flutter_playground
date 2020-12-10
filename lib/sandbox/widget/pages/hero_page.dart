import 'package:flutter/material.dart';

import 'demo_page.dart';

class HeroPage extends DemoPage {
  @override
  Widget buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tap lego heros to make them fly!',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: MediaQuery.of(context).size.width ~/ 80,
            children: [
              for (int i = 0; i < 9; ++i)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _ImageHero(
                    imageName: 'assets/images/lego_$i.jpg',
                    borderRadius: 80,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            return _HeroDetailsPage(
                              imageName: 'assets/images/lego_$i.jpg',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/*
*/
class _ImageHero extends StatelessWidget {
  const _ImageHero(
      {Key key, @required this.imageName, this.borderRadius = 0, this.onTap})
      : super(key: key);

  final String imageName;
  final double borderRadius;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Hero(
      tag: imageName,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Image.asset(
            imageName,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _HeroDetailsPage extends StatelessWidget {
  final String imageName;

  _HeroDetailsPage({@required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Details'),
      ),
      body: ListView(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _ImageHero(
              imageName: imageName,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
              'sed do eiusmod tempor incididunt ut labore et dolore magna '
              'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
              'ullamco laboris nisi ut aliquip ex ea commodo consequat. '
              'Duis aute irure dolor in reprehenderit in voluptate velit '
              'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
              'occaecat cupidatat non proident, sunt in culpa qui officia '
              'deserunt mollit anim id est laborum.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
