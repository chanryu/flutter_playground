import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_StateChangeNotifier>(
      create: (_) => _StateChangeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Sandbox'),
          actions: [
            _SortButton(),
          ],
        ),
        body: ProgrammingLanguageList(),
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
        final state = context.read<_StateChangeNotifier>();
        state.orderBy = orderBy;
      },
      itemBuilder: (BuildContext context) {
        final state = context.read<_StateChangeNotifier>();
        final List<String> choices = ['name', 'year'];
        return <PopupMenuItem<String>>[
          for (final choice in choices)
            PopupMenuItem<String>(
              value: choice,
              child: Row(
                children: [
                  Opacity(
                    opacity: state.orderBy == choice ? 1 : 0,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    choice[0].toUpperCase() + choice.substring(1), // Captialize
                    style: TextStyle(
                        fontWeight: state.orderBy == choice
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

class _StateChangeNotifier extends ChangeNotifier {
  String _orderBy = 'year';

  String get orderBy => _orderBy;
  set orderBy(String orderBy) {
    _orderBy = orderBy;
    notifyListeners();
  }
}

class ProgrammingLanguageModel {
  final String name;
  final String designers;
  final int year;
  final String logoURL;

  ProgrammingLanguageModel(
      {this.name, this.designers, this.year, this.logoURL});

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
    final orderBy = context.watch<_StateChangeNotifier>();
    final collectionRef = FirebaseFirestore.instance.collection('languages');
    final snapshotStream = collectionRef.orderBy(orderBy.orderBy).snapshots();

    return StreamBuilder(
      stream: snapshotStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something wrong...'));
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
