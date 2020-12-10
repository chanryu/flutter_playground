import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'sandbox/firebase/firebase_sandbox.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class _PageRouteContext {
  final String title;
  final String routeName;
  final WidgetBuilder pageBuilder;

  const _PageRouteContext({
    @required this.title,
    @required this.routeName,
    @required this.pageBuilder,
  });
}

final List<_PageRouteContext> _kPageRouteContexts = [
  _PageRouteContext(
    title: 'Firebase Sandbox',
    routeName: '/FirebaseSandbox',
    pageBuilder: (_) => FirebaseSandbox(),
  ),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Playground',
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        for (final context in _kPageRouteContexts)
          context.routeName: context.pageBuilder,
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Playground"),
      ),
      body: Center(
        child: ListView.separated(
          itemCount: _kPageRouteContexts.length,
          itemBuilder: (_, index) {
            final page = _kPageRouteContexts[index];
            return ListTile(
                title: Text(page.title),
                trailing: Icon(Icons.navigate_next_rounded),
                onTap: () {
                  Navigator.pushNamed(context, page.routeName);
                });
          },
          separatorBuilder: (_, __) => Divider(),
        ),
      ),
    );
  }
}
