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
  String _apiRoot = 'http://142e6815.ngrok.io/api/';
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
      Map decoded = json.decode(response.body)['data'];
      List<Transaction> transactions = new List<Transaction>();
      List<Category> categories = new List<Category>();
      for (var transaction in decoded['transactions']) {
        transactions.add(Transaction.fromJson(transaction));
      }

      for (var category in decoded['categories']) {
        categories.add(Category.fromJson(category));
      }

      return User.fromJson(
          json.decode(response.body)['data'], transactions, categories);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(),
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
          return SizedBox(
              child: CircularProgressIndicator(), height: 100.0, width: 100.0);
        },
      );
    }
    return null;
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
    IconButton button;
    if (_currentUser != null) {
      button = IconButton(
        icon: Icon(Icons.person),
        onPressed: _handleSignOut,
      );
    } else {
      button = IconButton(
        icon: Icon(Icons.input),
        onPressed: _handleSignIn,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
          actions: <Widget>[button],
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

class User {
  final int id;
  final String mongoId;
  final List<Transaction> transactions;
  final List<Category> categories;
  final String budget;

  User(
      {this.id, this.mongoId, this.transactions, this.categories, this.budget});

  factory User.fromJson(Map<String, dynamic> json, transactions, categories) {
    return User(
        id: json['userId'],
        mongoId: json['_id'],
        budget: json['budget'],
        transactions: transactions,
        categories: categories);
  }
}

class Transaction {
  final List<TransactionCategory> categories;
  final String mongoId;
  final String name;
  final double value;
  final String type;
  final String date;
  final String createdAt;
  final String updatedAt;

  Transaction(
      {this.categories,
      this.mongoId,
      this.name,
      this.value,
      this.type,
      this.date,
      this.createdAt,
      this.updatedAt});

  factory Transaction.fromJson(Map<String, dynamic> jsonMap) {
    var categories = (jsonMap['categories'] as List)
        .map((i) => TransactionCategory.fromJson(i))
        .toList();
    return Transaction(
        categories: categories,
        mongoId: jsonMap['_id'],
        name: jsonMap['name'],
        value: jsonMap['value'].toDouble(),
        type: jsonMap['type'],
        date: jsonMap['date'],
        createdAt: jsonMap['createdAt'],
        updatedAt: jsonMap['updatedAt']);
  }
}

class TransactionCategory {
  final String name;
  TransactionCategory({this.name});

  factory TransactionCategory.fromJson(String name) {
    return TransactionCategory(name: name);
  }
}

class Category {
  final String mongoId;
  final String name;
  final List<String> keywords;

  Category({this.mongoId, this.name, this.keywords});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(mongoId: json['_id'], name: json['name']);
  }
}
