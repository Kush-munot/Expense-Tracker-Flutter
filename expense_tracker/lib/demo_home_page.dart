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

  String balance = "₹ 0";
  String income = "₹ 0";
  String expense = "₹ 0";

  void _newTransaction() {
    String expenseOrIncome = 'Select';
    String title = '';
    String amount = '';
    String message = '';
    String category = 'Category';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Transaction"),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<String>(
                  value: expenseOrIncome,
                  items: <String>['Expense', 'Income'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      expenseOrIncome = newValue!;
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  onChanged: (value) {
                    amount = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Message'),
                  onChanged: (value) {
                    message = value;
                  },
                ),
                DropdownButton<String>(
                  value: category,
                  items: <String>[
                    'Milk',
                    'Grocery',
                    'Vegetable & Fruits',
                    'Petrol',
                    'Iron Clothes',
                    'Bills',
                    'Card Payment',
                    'UPI Payment',
                    'Snacks',
                    'GM Bus Fare',
                    'Extras',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                final transactionData = {
                  "Amount": double.parse(amount),
                  "Expense/Income": expenseOrIncome,
                  // "Date": DateTime.now().toUtc().toIso8601String(),
                  "Date": _getFormattedDate(DateTime.now()),
                  "Category": category,
                  "Message": message,
                };
                postTransactionData(transactionData);

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getFormattedDate(DateTime dateTime) {
    // Format the date as "MM/dd/yyyy"
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
  }

  Future<void> fetchData() async {
    // Replace with your API URL
    const apiUrl =
        'https://script.google.com/macros/s/AKfycbxs4S1kZcXrjG4G5Xv5CrGfPBSNR-VFfwWOmtCTN1Lp_D1gtC9DVMPGbsQKN1ocHjGW/exec';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Transaction> fetchedTransactions = data.map((item) {
          return Transaction(
            transactionName: item['Message'],
            money: item['Amount'].toString(),
            expenseOrIncome: item['Expense/Income'],
            category: item['Category'],
            message: item['Message'],
          );
        }).toList();

        // Calculate balance, income, and expense
        double totalIncome = 0;
        double totalExpense = 0;

        for (var transaction in fetchedTransactions) {
          if (transaction.expenseOrIncome == 'Income') {
            totalIncome += double.parse(transaction.money);
          } else if (transaction.expenseOrIncome == 'Expense') {
            totalExpense += double.parse(transaction.money);
          }
        }

        // Update state variables
        setState(() {
          transactions = fetchedTransactions;
          income = '₹ $totalIncome';
          expense = '₹ $totalExpense';
          balance = '₹ ${totalIncome - totalExpense}';
        });
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> postTransactionData(Map<String, dynamic> transactionData) async {
    print(json.encode(transactionData));
    // You'll need to replace the URL and handle the response accordingly
    const postApiUrl =
        'https://script.google.com/macros/s/AKfycbxs4S1kZcXrjG4G5Xv5CrGfPBSNR-VFfwWOmtCTN1Lp_D1gtC9DVMPGbsQKN1ocHjGW/exec';

    try {
      final response = await http.post(
        Uri.parse(postApiUrl),
        body: json.encode(transactionData),
      );

      if (response.statusCode == 200) {
        print('Data posted successfully');
      } else {
        print('Failed to post data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TopCard(balance: balance, income: income, expense: expense),
          Center(
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
          PlusButton(
            function: _newTransaction,
          ),
        ],
      ),
    );
  }
}
