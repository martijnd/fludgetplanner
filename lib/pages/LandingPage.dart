import 'package:fludgetplanner/classes.dart';
import 'package:fludgetplanner/components/LogoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:fludgetplanner/data.dart';
import 'package:intl/intl.dart';

class LandingPage extends StatefulWidget {
  final GoogleSignInAccount currentUser;

  LandingPage({Key key, this.currentUser}) : super(key: key);

  @override
  State createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  User user;
  List<Transaction> transactions;
  List<Category> categories;
  final currencyFormat = NumberFormat("#,##0.00", 'nl_NL');
  final dateFormat = DateFormat('dd-MM-yyyy');
  final repeatTranslations = {
    'once': 'Eenmalig',
    'daily': 'Dagelijks',
    'weekly': 'Wekelijks',
    'monthly': 'Maandelijks',
    'yearly': 'Jaarlijks'
  };

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLandingPage() {
    return FutureBuilder<User>(
      future: data.fetchUser(widget.currentUser.id),
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
                text: data.calculateBudget(
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
                trailing: Text(
                  "${repeatTranslations[transaction.repeat] ?? 'Eenmalig'} - ${dateFormat.format(DateTime.parse(transaction.date))}",
                  style: TextStyle(color: Colors.grey),
                ),
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
}
