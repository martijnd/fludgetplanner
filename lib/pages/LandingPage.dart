import 'dart:convert' as json;

import 'package:fludgetplanner/classes.dart';
import 'package:fludgetplanner/components/LogoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import "package:http/http.dart" as http;

class LandingPage extends StatefulWidget {
  final GoogleSignInAccount currentUser;

  LandingPage({Key key, this.currentUser}) : super(key: key);

  @override
  State createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  String _apiRoot = 'https://budgetplanner-backend.herokuapp.com/api/';
  User user;
  List<Transaction> transactions;
  List<Category> categories;
  final currencyFormat = NumberFormat("#,##0.00", 'nl_NL');
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
  }

  Future<User> _fetchUser() async {
    final response = await http.get(_apiRoot + widget.currentUser.id);

    if (response.statusCode == 200 &&
        json.jsonDecode(response.body)['success']) {
      Map decoded = json.jsonDecode(response.body)['data'];
      List<Transaction> transactions = new List<Transaction>();
      List<Category> categories = new List<Category>();
      for (var transaction in decoded['transactions']) {
        transactions.add(Transaction.fromJson(transaction));
      }

      for (var category in decoded['categories']) {
        categories.add(Category.fromJson(category));
      }

      return User.fromJson(
          json.jsonDecode(response.body)['data'], transactions, categories);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Widget _buildLandingPage() {
    return FutureBuilder<User>(
      future: _fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              _buildBudgetDisplay(snapshot.data),
              _buildTransactionList(snapshot.data.transactions)
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildBudgetDisplay(User user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7.0, 10.0, 7.0, 10.0),
      child: ListTile(
        leading: GoogleUserCircleAvatar(
          identity: widget.currentUser,
        ),
        title: RichText(
            text: TextSpan(
                text: _calculateBudget(
                    double.parse(user.budget), user.transactions),
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return Expanded(
        child: ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final Transaction transaction =
            transactions[transactions.length - index - 1];

        if (transaction.type != "hidden") {
          return Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Text(transaction.name[0].toUpperCase()),
                  backgroundColor:
                      transaction.type == 'expense' ? Colors.red : Colors.green,
                ),
                title: Text(transaction.name),
                subtitle: Text("€ ${currencyFormat.format(transaction.value)}"),
                trailing:
                    Text(dateFormat.format(DateTime.parse(transaction.date))),
              ),
              ButtonTheme.bar(
                  child: ButtonBar(
                children: <Widget>[
                  FlatButton(child: Text('DELETE'), onPressed: () {})
                ],
              ))
            ],
          ));
        } else {
          return SizedBox(
            child: null,
          );
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Fludgetplanner'),
          actions: <Widget>[LogoutButton()],
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Material(
            child: _buildLandingPage(),
          ),
        ));
  }

  String _calculateBudget(double budget, List<Transaction> transactions) {
    transactions.forEach((Transaction transaction) {
      if (transaction.type == 'expense') {
        return budget -= transaction.value;
      }
      return budget += transaction.value;
    });

    return "€ ${currencyFormat.format(budget)}";
  }
}
