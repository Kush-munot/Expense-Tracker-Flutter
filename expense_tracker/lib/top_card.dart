import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;
  const TopCard(
      {Key? key,
      required this.balance,
      required this.expense,
      required this.income})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 15.0, 8, 0),
      color: Colors.grey[300],
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("B A L A N C E",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text(balance,
                style: TextStyle(color: Colors.grey[800], fontSize: 36)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.arrow_upward,
                        color: Colors.green, size: 32), // Adjust the size here
                    const Text('Income',
                        style: TextStyle(color: Colors.green, fontSize: 16)),
                    Text(income,
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.arrow_downward,
                        color: Colors.red, size: 32), // Adjust the size here
                    const Text('Expense',
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                    Text(expense,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 18)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
