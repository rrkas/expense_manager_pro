import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionEntity {
  int id;
  DateTime dateTime;
  double amount, balance;
  bool isDebit = false;
  String title, remark;

  static double finalBalance = 0.0;

  static String get finalBalanceFormatted {
    if (finalBalance < 0)
      return '${(finalBalance * -1).toStringAsFixed(2)} Dr';
    else
      return '${finalBalance.toStringAsFixed(2)} Cr';
  }

  TransactionEntity({
    @required this.id,
    @required this.dateTime,
    @required this.amount,
    @required this.title,
    @required this.isDebit,
    @required this.remark,
  });

  TransactionEntity.blank();

  Map<String, Object> get toMap {
    Map<String, Object> map = {
      dateTimeField: dateTime.toIso8601String(),
      amountField: amount,
      titleField: title,
      isDebitField: isDebit ? 1 : 0,
      remarkField: remark,
    };
    if (id != null) map[idField] = id;
    return map;
  }

  TransactionEntity.fromMap(Map<String, Object> map) {
    id = map[idField];
    dateTime = DateTime.parse(map[dateTimeField]);
    amount = map[amountField];
    title = map[titleField];
    isDebit = map[isDebitField] == 1;
    remark = map[remarkField];
    if (isDebit) {
      balance = finalBalance - amount;
    } else {
      balance = finalBalance + amount;
    }
    finalBalance = balance;
  }

  double get absoluteBalance => balance < 0 ? balance * -1 : balance;

  static String get dbName => 'transactions.db';

  static String get tableName => 'Transactions';

  static String get idField => 'id';

  static String get dateTimeField => 'dateTime';

  static String get amountField => 'amount';

  static String get titleField => 'title';

  static String get isDebitField => 'isDebit';

  static String get remarkField => 'remark';

  static List<String> get excelHeaders => [
        'Sl. No.',
        'Date',
        'Particulars',
        'Credit (Rs.)',
        'Debit (Rs.)',
        'Balance Cr (Rs.)',
        'Balance Dr (Rs.)',
        'Remarks',
      ];

  List excelRow(int slno) => [
        slno,
        DateFormat('dd MMM yyyy').format(dateTime),
        title,
        isDebit ? null : amount,
        isDebit ? amount : null,
        balance > 0 ? balance : null,
        balance < 0 ? absoluteBalance : null,
        remark,
      ];
}

// debit = remove
// credit = add
