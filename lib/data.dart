import 'dart:convert' as json;

import 'package:fludgetplanner/classes.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';

class Data {
  final String _apiRoot = 'https://budgetplanner-backend.herokuapp.com/api/';
  final String budget;
  final currencyFormat = NumberFormat("#,##0.00", 'nl_NL');
  final dateFormat = DateFormat('dd-MM-yyyy');

  Data({this.budget});

  Future<User> fetchUser(String userId) async {
    final response = await http.get(_apiRoot + userId);

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

  String calculateBudget(double budget, List<Transaction> transactions) {
    transactions.forEach((Transaction transaction) {
      if (transaction.type == 'expense') {
        return budget -= transaction.value;
      }
      return budget += transaction.value;
    });

    return "€ ${currencyFormat.format(budget)}";
  }
}

final Data data = Data();
