// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() {
  runApp(
    MaterialApp(
      title: 'Google Sign In',
      home: LandingPage(),
    ),
  );
}

class LandingPage extends StatefulWidget {
  @override
  State createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  GoogleSignInAccount _currentUser;
  String _apiRoot = 'http://021d49f6.ngrok.io/api/';
  User user;
  List<Transaction> transactions;
  List<Category> categories;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    // _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  Future<User> _fetchUser() async {
    final response = await http.get(_apiRoot + _currentUser.id);

    if (response.statusCode == 200 && json.decode(response.body)['success']) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName),
            subtitle: Text(_currentUser.email),
          ),
          const Text("Signed in successfully."),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          Expanded(
              child: Container(
            decoration: new BoxDecoration(),
            child: _buildUserInfo(),
          ))
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  Widget _buildUserInfo() {
    if (_currentUser != null) {
      return FutureBuilder<User>(
        future: _fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildTransactionList(snapshot.data.transactions);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      );
    }
  }

  Widget _buildTransactionList(transactions) {
    print("transactions length: ${transactions.length}");
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final Transaction transaction = transactions[index];

        return ListTile(
          title: Text(transaction.name),
          subtitle: Text(transaction.value.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

class User {
  int id;
  String mongoId;
  List<Transaction> transactions;
  List<Category> categories;
  String budget;

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['userId'];
    this.mongoId = json['_id'];
    this.transactions = [];
    this.categories = [];
    this.budget = '';
    final _transactionList = json['transactions'];

    for (var i = 0; i < _transactionList.length; i++) {
      this.transactions.add(new Transaction.fromJson(_transactionList[i]));
    }
  }
}

class Transaction {
  List<String> categories;
  String mongoId;
  String name;
  int value;
  String type;
  String date;
  String createdAt;
  String updatedAt;

  Transaction.fromJson(Map<String, dynamic> json) {
    this.categories = json['categories'];
    this.mongoId = json['_id'];
    this.name = json['name'];
    this.value = json['value'];
    this.type = json['type'];
    this.date = json['date'];
    this.createdAt = json['createdAt'];
    this.updatedAt = json['updatedAt'];
  }
}

class Category {
  final String mongoId;
  final String name;
  final List<String> keywords;

  Category({this.mongoId, this.name, this.keywords});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        mongoId: json['_id'], name: json['name'], keywords: json['keywords']);
  }
}
