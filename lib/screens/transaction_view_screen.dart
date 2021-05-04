import 'package:expense_planner_pro/models/transaction.dart';
import 'package:expense_planner_pro/screens/transaction_edit_screen.dart';
import 'package:expense_planner_pro/services/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionViewScreen extends StatelessWidget {
  static const routeName = '/transaction-view';

  @override
  Widget build(BuildContext context) {
    TransactionEntity t = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction View'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).pushNamed(TransactionEditScreen.routeName, arguments: t);
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (c) => AlertDialog(
                  title: Center(child: Text('Are You Sure?')),
                  content: Text('Do you want to delete this transaction?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        LocalDbService.delete(t);
                      },
                      child: Text('YES'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('NO'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: t == null
          ? Center(
              child: Text('Loading...'),
            )
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              children: [
                _row('Title', t.title),
                _row(
                  'Amount',
                  t.amount.toStringAsFixed(2) + (t.isDebit ? ' Dr' : ' Cr'),
                  TextStyle(color: t.isDebit ? Colors.red[700] : Colors.indigo, fontWeight: FontWeight.bold),
                ),
                _row('Date', DateFormat('dd MMM yyyy').format(t.dateTime)),
                _row(
                  'Balance',
                  t.balance.toStringAsFixed(2) + (t.balance < 0 ? ' Dr' : ' Cr'),
                  TextStyle(color: t.balance < 0 ? Colors.red[700] : Colors.indigo, fontWeight: FontWeight.bold),
                ),
                _row('Remark', t.remark),
              ],
            ),
    );
  }

  Widget _row(String title, String text, [TextStyle textStyle]) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 2,
              child: Text(
                text,
                style: TextStyle(fontSize: 16).merge(textStyle),
              ),
            ),
          ],
        ),
      );
}
