import 'dart:math';

import 'package:flutter/material.dart';

import 'demo_page.dart';

class AnimatedIconPage extends DemoPage {
  @override
  Widget buildBody(BuildContext context) {
    const animatedIcons = const [
      // add <-> event
      AnimatedIcons.add_event,
      AnimatedIcons.event_add,

      // list <-> view
      AnimatedIcons.list_view,
      AnimatedIcons.view_list,

      // menu <-> *
      AnimatedIcons.home_menu,
      AnimatedIcons.menu_home,
      AnimatedIcons.arrow_menu,
      AnimatedIcons.menu_arrow,
      AnimatedIcons.close_menu,
      AnimatedIcons.menu_close,

      // play <-> pause
      AnimatedIcons.play_pause,
      AnimatedIcons.pause_play,

      // ellipsis <-> search
      AnimatedIcons.ellipsis_search,
      AnimatedIcons.search_ellipsis,
    ];

    final crossAxisCount = MediaQuery.of(context).size.width ~/ 80;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: animatedIcons.map((icon) {
        return Card(
          child: Center(
            child: _SelfRotatingIcon(icon: icon),
          ),
        );
      }).toList(),
    );
  }
}

class _SelfRotatingIcon extends StatefulWidget {
  final AnimatedIconData icon;
  _SelfRotatingIcon({this.icon});

  @override
  _SelfRotatingIconState createState() => _SelfRotatingIconState();
}

class _SelfRotatingIconState extends State<_SelfRotatingIcon>
    with SingleTickerProviderStateMixin {
  static const kAnimationDuration = Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: kAnimationDuration,
    );

    _continueLoop = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => loopAnimation());
  }

  @override
  void deactivate() {
    _continueLoop = false;
    super.deactivate();
  }

  @override
  void dispose() {
    assert(_continueLoop == false);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      size: 36,
      icon: widget.icon,
      progress: _animationController,
    );
  }

  Future<void> loopAnimation() async {
    // Wait up to 1 sec random delay so that icons can start animation
    // at slightly different timepoint.
    await Future.delayed(Duration(milliseconds: Random.secure().nextInt(1000)));

    // animation steps.
    final steps = [
      () => _animationController.forward(),
      () => Future.delayed(const Duration(milliseconds: 500)),
      () => _animationController.reverse(),
      () => Future.delayed(const Duration(milliseconds: 500)),
    ];
    while (_continueLoop) {
      for (final step in steps) {
        if (!_continueLoop) break;
        await step();
      }
    }
  }

  bool _continueLoop;
  AnimationController _animationController;
}
