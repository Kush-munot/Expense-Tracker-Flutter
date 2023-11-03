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
                items:
                    <String>['Cash', 'UPI', 'Credit Card'].map((String value) {
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
                keyboardType: TextInputType.number,
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
