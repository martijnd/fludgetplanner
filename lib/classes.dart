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
