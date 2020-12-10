import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseSandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Sandbox'),
      ),
      body: ProgrammingLanguageList(orderBy: 'year'),
    );
  }
}

class ProgrammingLanguage {
  final String name;
  final String designers;
  final int year;
  final String logoURL;

  ProgrammingLanguage({this.name, this.designers, this.year, this.logoURL});

  factory ProgrammingLanguage.fromDocument(DocumentSnapshot snapshot) {
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
    return ProgrammingLanguage(
      name: name,
      designers: designers,
      year: year,
      logoURL: logoURL,
    );
  }
}

class ProgrammingLanguageList extends StatelessWidget {
  final String orderBy;

  ProgrammingLanguageList({Key key, this.orderBy}) : super(key: key);

  static const kListItemTitleTextStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance.collection('languages');
    final snapshotStream = orderBy == null
        ? collectionRef.snapshots()
        : collectionRef.orderBy(orderBy).snapshots();

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
            final lang = ProgrammingLanguage.fromDocument(docs[index]);
            return ListTile(
              leading: Image.network(lang.logoURL, width: 48, height: 48),
              title: Text(lang.name, style: kListItemTitleTextStyle),
              subtitle: Text('Since ${lang.year} - ${lang.designers}'),
            );
          },
          separatorBuilder: (context, index) => Divider(indent: 16),
        );
      },
    );
  }
}
