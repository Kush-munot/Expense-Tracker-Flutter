import 'package:expense_tracker/plus_button.dart';
import 'package:expense_tracker/top_card.dart';
import 'package:expense_tracker/transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  createState() => _HomePageState();
}

/* class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          TopCard(
            balance: "₹ 100",
            income: "₹ 300",
            expense: "₹ 400",
          ),
          Expanded(
            child: Container(
              color: Colors.blue[300],
              child: Center(child: Text("Transactions")),
            ),
          ),
          Container(
            height: 500,
            child: Center(
              child: Text('Button'),
            ),
          ),
        ],
      ),
    );
  }
}
 */

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        // Use ListView with shrinkWrap
        shrinkWrap: true,
        children: const [
          TopCard(balance: "₹ 100", income: "₹ 300", expense: "₹ 400"),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Transaction(
                    transactionName: "UPI Payment",
                    money: "100",
                    expenseOrIncome: "income",
                    category: "UPI",
                    message: "Elit velit tempor dolor deserunt et.",
                  ),
                  Transaction(
                    transactionName: "UPI Payment",
                    money: "100",
                    expenseOrIncome: "expense",
                    category: "Fruits and Vegetables",
                    message: "Elit velit tempor dolor deserunt et.",
                  ),
                  Transaction(
                    transactionName: "UPI Payment",
                    money: "100",
                    expenseOrIncome: "income",
                    category: "UPI",
                    message: "Elit velit tempor dolor deserunt et.",
                  ),
                  Transaction(
                    transactionName: "UPI Payment",
                    money: "100",
                    expenseOrIncome: "expense",
                    category: "UPI",
                    message: "Elit velit tempor dolor deserunt et.",
                  ),
                  Transaction(
                    transactionName: "UPI Payment",
                    money: "100",
                    expenseOrIncome: "expense",
                    category: "UPI",
                    message: "Elit velit tempor dolor deserunt et.",
                  ),
                ],
              ),
            ),
          ),
          PlusButton(),
        ],
      ),
    );
  }
}
