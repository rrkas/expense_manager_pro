import 'package:expense_planner_pro/models/transaction.dart';
import 'package:expense_planner_pro/screens/transaction_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionEntity transactionEntity;
  final int idx;
  final Function refresh;

  TransactionWidget(this.transactionEntity, this.idx, this.refresh);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: idx.isEven ? Colors.white : Colors.grey[100],
      // focusColor: Colors.orange,
      onTap: () async {
        print('tap ${transactionEntity.id}');
        await Navigator.of(context).pushNamed(TransactionViewScreen.routeName, arguments: transactionEntity);
        refresh();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      (idx + 1).toString(),
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              VerticalDivider(thickness: 1),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionEntity.title,
                        style: TextStyle(fontSize: 17),
                        maxLines: 1,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(transactionEntity.dateTime),
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(thickness: 1),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      transactionEntity.amount.toStringAsFixed(2) + (transactionEntity.isDebit ? ' Dr' : ' Cr'),
                      maxLines: 1,
                      style: TextStyle(color: transactionEntity.isDebit ? Colors.red[700] : Colors.indigo, fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              VerticalDivider(thickness: 1),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      transactionEntity.absoluteBalance.toStringAsFixed(2) + (transactionEntity.balance < 0 ? 'Dr' : 'Cr'),
                      maxLines: 1,
                      style: TextStyle(color: transactionEntity.balance < 0 ? Colors.red[700] : Colors.indigo, fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
