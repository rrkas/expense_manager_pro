import 'dart:io';

import 'package:excel/excel.dart';
import 'package:expense_planner_pro/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ExcelUtil {
  static final _sheetName = 'Transactions';

  static Future<File> generateExcel(List<TransactionEntity> transactions) async {
    Excel excel = Excel.createExcel();
    final now = DateTime.now();
    excel.rename(excel.sheets.keys.first, _sheetName);
    Sheet sheet = excel[_sheetName];

    sheet.appendRow(['REPORT']);
    sheet.appendRow(['Generated On', DateFormat('dd MMM yyyy').format(now) + ' at ' + DateFormat('HH:mm:ss').format(now)]);
    sheet.appendRow(TransactionEntity.excelHeaders);
    for (int i = 0; i < transactions.length; i++) sheet.appendRow(transactions[i].excelRow(i + 1));

    File f = File(join((await getTemporaryDirectory()).path, 'Excel', DateFormat('yyyyMMdd-HHmmss').format(now) + '.xlsx'));
    f.createSync(recursive: true);
    f.writeAsBytes(await excel.encode());
    return f;
  }
}
