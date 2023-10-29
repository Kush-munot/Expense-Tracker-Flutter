import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = []; // List to store fetched transactions

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchData();
  }

  Future<void> fetchData() async {
    const apiUrl =
        'https://script.google.com/macros/s/AKfycbzAmPGWoG6N9cE2fxOFyWPoRu5rGu3gcJsmVajmbhgNet-xAeqC5_CeNZSx3EpdMwSN/exec';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Assuming your API response is a list of transactions
        final List<Transaction> fetchedTransactions = data.map((item) {
          return Transaction(
            transactionName: item['Message'],
            money: item['Amount'].toString(),
            expenseOrIncome: item['Expense/Income'],
            category: item['Category'],
            message: item['Message'],
          );
        }).toList();

        // Set the state to refresh the widget with the fetched data
        setState(() {
          transactions = fetchedTransactions;
        });
      } else {
        // Handle API error
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or JSON decoding error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        // Use ListView with shrinkWrap
        shrinkWrap: true,
        children: <Widget>[
          TopCard(balance: "₹ 100", income: "₹ 300", expense: "₹ 400"),
          Expanded(
            child: Center(
              child: Column(
                children: transactions.map((transaction) {
                  return Transaction(
                    transactionName: transaction.transactionName,
                    money: transaction.money,
                    expenseOrIncome: transaction.expenseOrIncome,
                    category: transaction.category,
                    message: transaction.message,
                  );
                }).toList(),
              ),
            ),
          ),
          PlusButton(),
        ],
      ),
    );
  }
}
