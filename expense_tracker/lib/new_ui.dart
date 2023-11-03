import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expense_tracker/transaction_dialog.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return TransactionDialog(
          onSave: (transactionData) async {
            await postTransactionData(transactionData);
            Navigator.of(context).pop();
            await fetchData();
          },
        );
      },
    );
  }

  Future<void> fetchData() async {
    String expenseApi = dotenv.get("API_URL_KUSH");

    try {
      final response = await http.get(Uri.parse(expenseApi));
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
    String expenseApi = dotenv.get("API_URL_KUSH");
    // print(json.encode(transactionData));

    try {
      final response = await http.post(Uri.parse(expenseApi),
          body: json.encode(transactionData),
          headers: {"Accept": "application/json"});

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160, // Adjust this as needed
            flexibleSpace: FlexibleSpaceBar(
              background:
                  TopCard(balance: balance, income: income, expense: expense),
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index == -1) {
                return Container(); // This is a placeholder to ensure the first item is not sticky
              }
              final transactionIndex = transactions.length - index;
              return Transaction(
                transactionName:
                    transactions[transactionIndex - 1].transactionName,
                money: transactions[transactionIndex - 1].money,
                expenseOrIncome:
                    transactions[transactionIndex - 1].expenseOrIncome,
                category: transactions[transactionIndex - 1].category,
                message: transactions[transactionIndex - 1].message,
              );
            }, childCount: transactions.length),
          ),
        ],
      ),
      floatingActionButton: PlusButton(function: _newTransaction),
    );
  }
}
