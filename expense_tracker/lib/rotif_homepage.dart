import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    fetchData();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle the received local notification here
        if (payload != null) {
          debugPrint('Received local notification with payload: $payload');
        }
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (String? payload) {
        if (payload != null) {
          debugPrint('Notification payload: $payload');
        }
      },
    );
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle received notification
  }

  void _newTransaction() {
    String expenseOrIncome = 'Expense';
    String modeOfPayment = 'Cash';
    String title = '';
    String amount = '';
    String message = '';
    String category = 'Milk';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Transaction"),
          content: SingleChildScrollView(
            child: Form(
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
                  DropdownButton<String>(
                    value: modeOfPayment,
                    items: <String>['Cash', 'UPI', 'Credit Card']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        modeOfPayment = newValue!;
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
                      'Snacks',
                      'GM Bus Fare',
                      'Monthly Budget',
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
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final transactionData = {
                  "Amount": double.parse(amount),
                  "Expense/Income": expenseOrIncome,
                  "Date": _getFormattedDate(DateTime.now()),
                  "ModeOfPayment": modeOfPayment,
                  "Category": category,
                  "Message": message,
                };
                await postTransactionData(transactionData);

                Navigator.of(context).pop();

                await fetchData();
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
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
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
      } else {
        print('Failed to post data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting data: $e');
    }
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
