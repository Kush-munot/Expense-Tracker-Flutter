// import 'package:expense_tracker/demo_home_page.dart';
import 'dart:convert';

import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/theme/theme_constants.dart';
import 'package:expense_tracker/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:expense_tracker/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

ThemeManager _themeManager = ThemeManager();
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListner);
    super.dispose();
  }

  // This widget is the root of your application.
  void initState() {
    _themeManager.addListener(themeListner);
    super.initState();
  }

  themeListner() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Transaction> transactions = [];
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
            modeOfPayment: item['ModeOfPayment'],
          );
        }).toList();

        double totalIncome = 0;
        double totalExpense = 0;

        for (var transaction in fetchedTransactions) {
          if (transaction.expenseOrIncome == 'Income') {
            totalIncome += double.parse(transaction.money);
          } else if (transaction.expenseOrIncome == 'Expense') {
            totalExpense += double.parse(transaction.money);
          }
        }

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

    try {
      final response = await http.post(Uri.parse(expenseApi),
          body: json.encode(transactionData),
          headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        print('Data posted successfully');
        // Update income and expense here if necessary
        fetchData();
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
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]
          : Colors.teal[300],
      appBar: AppBar(
        title: Text("Money Mate"),
        actions: [
          Switch(
            value: _themeManager.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              _themeManager.toggleTheme(newValue);
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TopCardDelegate(balance, income, expense),
            floating: false,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final transactionIndex = transactions.length - index;
                return Transaction(
                  transactionName:
                      transactions[transactionIndex - 1].transactionName,
                  money: transactions[transactionIndex - 1].money,
                  expenseOrIncome:
                      transactions[transactionIndex - 1].expenseOrIncome,
                  category: transactions[transactionIndex - 1].category,
                  message: transactions[transactionIndex - 1].message,
                  modeOfPayment:
                      transactions[transactionIndex - 1].modeOfPayment,
                );
              },
              childCount: transactions.length,
            ),
          ),
        ],
      ),
      floatingActionButton: PlusButton(function: _newTransaction),
    );
  }
}

class TopCardDelegate extends SliverPersistentHeaderDelegate {
  final String balance;
  final String income;
  final String expense;

  TopCardDelegate(this.balance, this.income, this.expense);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return TopCard(balance: balance, income: income, expense: expense);
  }

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 200.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
