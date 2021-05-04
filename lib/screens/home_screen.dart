import 'dart:io';

import 'package:expense_planner_pro/main.dart';
import 'package:expense_planner_pro/models/transaction.dart';
import 'package:expense_planner_pro/screens/generated_reports.dart';
import 'package:expense_planner_pro/screens/transaction_edit_screen.dart';
import 'package:expense_planner_pro/services/local_db_service.dart';
import 'package:expense_planner_pro/utils/excel_utils.dart';
import 'package:expense_planner_pro/widgets/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final skey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TransactionEntity>>(
      future: LocalDbService.getAllTransactions,
      builder: (ctx, snap) {
        Widget b;
        if (snap.data == null)
          b = Center(child: Text('Loading...'));
        else
          b = snap.data.isEmpty
              ? Center(
                  child: Text('No Transactions Yet!'),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Balance'),
                          Text(
                            TransactionEntity.finalBalanceFormatted,
                            style: TextStyle(
                              fontSize: 30,
                              color: TransactionEntity.finalBalance < 0 ? Colors.red[700] : Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: FittedBox(
                                  child: Center(
                                    child: Text(
                                      'Sl.',
                                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            Expanded(
                              flex: 6,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: Text(
                                    'Particulars',
                                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  'Amount',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            VerticalDivider(thickness: 1),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  'Balance',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 0, thickness: 1),
                    Expanded(
                      child: ListView.separated(
                        itemCount: snap.data.length,
                        itemBuilder: (_, idx) => TransactionWidget(snap.data[idx], idx, () => setState(() {})),
                        separatorBuilder: (_, __) => Divider(height: 0, thickness: 1),
                      ),
                    ),
                  ],
                );
        return Scaffold(
          key: skey,
          appBar: AppBar(
            title: Text('Expense Manager Pro'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  await Navigator.of(context).pushNamed(TransactionEditScreen.routeName, arguments: null);
                  setState(() {});
                },
              ),
              if (snap.data?.isNotEmpty ?? false)
                PopupMenuButton<int>(
                  offset: Offset(0, kToolbarHeight),
                  itemBuilder: (_) => [
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text('Export Excel'),
                    ),
                    // PopupMenuItem(
                    //   value: 2,
                    //   child: Text('Export PDF'),
                    // ),
                    PopupMenuItem(
                      value: 3,
                      child: Text('Clear All'),
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Text('Generated Reports'),
                    ),
                    PopupMenuItem(
                      value: 5,
                      child: Text('About'),
                    )
                  ],
                  onSelected: (idx) async {
                    switch (idx) {
                      case 1:
                        File f = await ExcelUtil.generateExcel(snap.data);
                        OpenFile.open(f.path);
                        break;
                      // case 2:
                      //   File f = await PdfUtil.generatePDF(snap.data);
                      //   OpenFile.open(f.path);
                      //   break;
                      case 3:
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: Center(child: Text('Are You Sure?')),
                            content: Text('Do you want to delete this transaction?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await LocalDbService.deleteAll();
                                  setState(() {});
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
                        break;
                      case 4:
                        Navigator.of(context).pushNamed(GeneratedReports.routeName);
                        break;
                      case 5:
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Expense Manager Pro'),
                                Text('v-$version', style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Contact:'),
                                Text('Rohnak Agawal', style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.call, color: Theme.of(context).primaryColor),
                                      onPressed: () async {
                                        final url = 'tel:+919658600961';
                                        if (await canLaunch(url))
                                          launch(url);
                                        else
                                          skey.currentState
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(SnackBar(content: Text('Failed to call!')));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.mail, color: Theme.of(context).primaryColor),
                                      onPressed: () async {
                                        final url = 'mailto:rrka79wal@gmail.com';
                                        if (await canLaunch(url))
                                          launch(url);
                                        else
                                          skey.currentState
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(SnackBar(content: Text('Failed to mail!')));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                        break;
                    }
                  },
                ),
            ],
          ),
          body: b,
        );
      },
    );
  }
}
