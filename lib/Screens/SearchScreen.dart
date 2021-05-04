import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterway/Consts.dart';
import 'dart:async';

import 'package:flutterway/Models/usermodel.dart';

class SearchScreen extends StatefulWidget {
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {
  Future<QuerySnapshot>? userDocs;

  buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Form(
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Search for a user...'),
          onFieldSubmitted: submit,
        ),
      ),
    );
  }

  ListView buildSearchResults(List<DocumentSnapshot> docs) {
    List<UserSearchItem> userSearchItems = [];
    docs.forEach((DocumentSnapshot doc) {
      UserModel user = UserModel.fromDocument(doc);
      UserSearchItem searchItem = UserSearchItem(user);
      userSearchItems.add(searchItem);
    });

    return ListView(
      children: userSearchItems,
    );
  }

  void submit(String searchvalue) {
    final Future<QuerySnapshot> users = usercollection.where('username', isGreaterThanOrEqualTo: searchvalue).get();
    setState(() {
      userDocs = users;
    });
  }

  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: buildSearchField(),
      body: userDocs == null
          ? Text("")
          : FutureBuilder<QuerySnapshot>(
              future: userDocs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return buildSearchResults(snapshot.data!.docs);
                } else {
                  return Container(alignment: FractionalOffset.center, child: CircularProgressIndicator());
                }
              }),
    );
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

class UserSearchItem extends StatelessWidget {
  final UserModel user;

  const UserSearchItem(this.user);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return GestureDetector(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: Text(user.username, style: boldStyle),
          subtitle: Text(user.username),
        ),
        onTap: () {
          //   openProfile(context, user.id);
        });
  }
}
