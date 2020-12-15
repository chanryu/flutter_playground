import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_in_form.dart';

class FirebaseSandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_AuthState>(
          create: (_) => _AuthState(),
        ),
        ChangeNotifierProvider<_OrderBy>(
          create: (_) => _OrderBy(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final authState = Provider.of<_AuthState>(context);
          if (authState.isUserLoggedIn()) {
            return _buildMainScaffold();
          }
          return _buildSignInScaffold();
        },
      ),
    );
  }

  Widget _buildSignInScaffold() {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Sandbox')),
      body: Container(
        margin: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SignInForm(
          onSubmit: (email, password) {
            FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programing Languages'),
        actions: [_SortButton()],
      ),
      body: ProgrammingLanguageList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.sort_rounded),
      onSelected: (String orderBy) {
        final state = context.read<_OrderBy>();
        state.value = orderBy;
      },
      itemBuilder: (BuildContext context) {
        final orderBy = context.read<_OrderBy>();
        final List<String> choices = ['name', 'year'];
        return <PopupMenuItem<String>>[
          for (final choice in choices)
            PopupMenuItem<String>(
              value: choice,
              child: Row(
                children: [
                  Opacity(
                    opacity: orderBy.value == choice ? 1 : 0,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    choice[0].toUpperCase() + choice.substring(1), // Captialize
                    style: TextStyle(
                        fontWeight: orderBy.value == choice
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                ],
              ),
            ),
        ];
      },
    );
  }
}

class _OrderBy with ChangeNotifier {
  String _value = 'year';

  String get value => _value;
  set value(String value) {
    _value = value;
    notifyListeners();
  }
}

class _AuthState with ChangeNotifier {
  _AuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  bool isUserLoggedIn() => _currentUser != null;

  User get currentUser => _currentUser;

  User _currentUser;
}

class ProgrammingLanguageModel {
  final String name;
  final String designers;
  final int year;
  final String logoURL;

  ProgrammingLanguageModel({
    this.name,
    this.designers,
    this.year,
    this.logoURL,
  });

  factory ProgrammingLanguageModel.fromDocument(DocumentSnapshot snapshot) {
    String name;
    String designers;
    int year;
    String logoURL;
    try {
      name = snapshot['name'];
      logoURL = snapshot['logo_url'];
      year = snapshot['year'];
      designers =
          snapshot['designers'].reduce((value, element) => '$value, $element');
    } on StateError catch (e) {
      print(e);
    }
    return ProgrammingLanguageModel(
      name: name,
      designers: designers,
      year: year,
      logoURL: logoURL,
    );
  }
}

class ProgrammingLanguageList extends StatelessWidget {
  ProgrammingLanguageList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderBy = context.watch<_OrderBy>();
    final collectionRef = FirebaseFirestore.instance.collection('languages');
    final snapshotStream = collectionRef.orderBy(orderBy.value).snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: snapshotStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return Center(child: Text('Loading...'));
        }

        final docs = snapshot.data.docs;
        return ListView.separated(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final model = ProgrammingLanguageModel.fromDocument(docs[index]);
            return ProgrammingLanguageListTile(model: model);
          },
          separatorBuilder: (context, index) => Divider(indent: 16),
        );
      },
    );
  }
}

class ProgrammingLanguageListTile extends StatelessWidget {
  const ProgrammingLanguageListTile({
    Key key,
    @required this.model,
  }) : super(key: key);

  static const kListItemTitleTextStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  final ProgrammingLanguageModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(model.logoURL, width: 48, height: 48),
      title: Text(model.name, style: kListItemTitleTextStyle),
      subtitle: Text('Since ${model.year} - ${model.designers}'),
    );
  }
}
