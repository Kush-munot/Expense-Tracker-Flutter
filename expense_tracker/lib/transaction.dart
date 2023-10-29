import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  const Transaction(
      {super.key,
      required this.transactionName,
      required this.money,
      required this.expenseOrIncome,
      required this.category,
      required this.message});

  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final String category;
  final String message;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: expenseOrIncome == 'Expense' ? Colors.red : Colors.green,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.grey[200],
          height: 56,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transactionName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      (expenseOrIncome == 'Expense' ? '- ' : '+ ') +
                          '₹ ' +
                          money,
                      style: textStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
