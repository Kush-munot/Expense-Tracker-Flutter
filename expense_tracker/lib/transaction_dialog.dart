import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  final Function(Map<String, dynamic> transactionData)
      onSave; // Define onSave callback

  TransactionDialog({required this.onSave});

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  String expenseOrIncome = 'Expense';
  String modeOfPayment = 'Cash';
  String amount = '';
  String message = '';
  String category = 'Milk';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Transaction"),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ... Your dropdowns and text fields here
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
            // Call the callback function to handle the data
            widget.onSave(transactionData);
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
  }

  String _getFormattedDate(DateTime dateTime) {
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
  }
}
