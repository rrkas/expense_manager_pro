// import 'dart:io';
//
// import 'package:expense_planner_pro/models/transaction.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
//
// class PdfUtil {
//   static Future<File> generatePDF(List<TransactionEntity> transactions) async {
//     final now = DateTime.now();
//     final pdf = Document(title: 'Transactions Report');
//
//     pdf.addPage(
//       MultiPage(
//         margin: EdgeInsets.all(PdfPageFormat.cm),
//         header: (ctx) => Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Align(alignment: Alignment.centerLeft, child: Text('REPORT')),
//                 ),
//                 Expanded(child: Center(child: Text('Expense Manager Pro', style: TextStyle(fontWeight: FontWeight.bold)))),
//                 Expanded(
//                   child: Align(alignment: Alignment.centerRight, child: Text(DateFormat('dd MMMM yyyy').format(now) + ' at ' + DateFormat('HH:mm:ss').format(now))),
//                 ),
//               ],
//             )),
//         footer: (ctx) => Align(
//           alignment: Alignment.centerRight,
//           child: Text('Page ${ctx.pageNumber}/${ctx.pagesCount}'),
//         ),
//         build: (c) => [
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Center(child: Text('REPORT', style: TextStyle(fontSize: 30))),
//               // _HeadingRow(),
//               // ...transactions.map((e) => _TransactionRow(e)).toList(),
//               // Wrap(children: [
//               //   Table.fromTextArray(
//               //     border: null,
//               //     headers: ['Date', 'Particulars', 'Credit (Rs.)', 'Debit (Rs.)', 'Balance (Rs.)', 'Remarks'],
//               //     data: [],
//               //     columnWidths: {
//               //       0: FlexColumnWidth(4),
//               //       1: FlexColumnWidth(8),
//               //       2: FlexColumnWidth(5),
//               //       3: FlexColumnWidth(5),
//               //       4: FlexColumnWidth(5),
//               //       5: FlexColumnWidth(4),
//               //     },
//               //     cellHeight: 40,
//               //     headerHeight: 30,
//               //     oddRowDecoration: BoxDecoration(color: PdfColors.grey100),
//               //     headerStyle: TextStyle(fontWeight: FontWeight.bold),
//               //     headerAlignment: Alignment.center,
//               //     cellAlignments: {
//               //       0: Alignment.center,
//               //       1: Alignment.centerLeft,
//               //       2: Alignment.centerRight,
//               //       3: Alignment.centerRight,
//               //       4: Alignment.centerRight,
//               //       5: Alignment.centerLeft,
//               //     },
//               //   ),
//               //   ...transactions
//               //       .map((e) => Table.fromTextArray(
//               //             border: null,
//               //             headers: ['Date', 'Particulars', 'Credit (Rs.)', 'Debit (Rs.)', 'Balance (Rs.)', 'Remarks'],
//               //             data: [
//               //               [
//               //                 DateFormat('dd/MM/yyyy').format(e.dateTime),
//               //                 e.title,
//               //                 e.isDebit ? '' : e.amount.toStringAsFixed(2),
//               //                 e.isDebit ? e.amount.toStringAsFixed(2) : '',
//               //                 e.absoluteBalance.toStringAsFixed(2) + ' ' + (e.balance < 0 ? 'Dr' : 'Cr'),
//               //                 e.remark,
//               //               ]
//               //             ],
//               //             columnWidths: {
//               //               0: FlexColumnWidth(4),
//               //               1: FlexColumnWidth(8),
//               //               2: FlexColumnWidth(5),
//               //               3: FlexColumnWidth(5),
//               //               4: FlexColumnWidth(5),
//               //               5: FlexColumnWidth(4),
//               //             },
//               //             cellHeight: 40,
//               //             headerHeight: 30,
//               //             oddRowDecoration: BoxDecoration(color: PdfColors.grey100),
//               //             headerStyle: TextStyle(fontWeight: FontWeight.bold),
//               //             // cellPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//               //             headerAlignment: Alignment.center,
//               //             cellAlignments: {
//               //               0: Alignment.center,
//               //               1: Alignment.centerLeft,
//               //               2: Alignment.centerRight,
//               //               3: Alignment.centerRight,
//               //               4: Alignment.centerRight,
//               //               5: Alignment.centerLeft,
//               //             },
//               //           ))
//               //       .toList(),
//               // ]),
//             ],
//           ),
//         ],
//       ),
//     );
//
//     File f = File(path.join((await getTemporaryDirectory()).path, 'PDF', DateFormat('yyyyMMdd-HHmmss').format(now) + '.pdf'));
//     f.createSync(recursive: true);
//     f.writeAsBytes(pdf.save());
//     return f;
//   }
// }
//
// // List get flexs => [2, 5, 3, 3, 3, 2];
// //
// // int get sumFlexes => flexs.fold(0, (previousValue, element) => previousValue + element);
// //
// // class _TransactionRow extends StatelessWidget {
// //   final TransactionEntity t;
// //
// //   _TransactionRow(this.t);
// //
// //   @override
// //   Widget build(Context context) {
// //     double size = 12;
// //     int testRepeat = 1, txtLen = 15;
// //     final sep = Container(
// //       margin: EdgeInsets.symmetric(horizontal: 5),
// //       width: 1,
// //       color: PdfColors.grey,
// //       height: 30,
// //     );
// //     final bstyle = BorderSide(style: BorderStyle.solid, color: PdfColors.black, width: 1);
// //     return Container(
// //       decoration: BoxDecoration(border: Border(top: bstyle, bottom: bstyle, right: bstyle, left: bstyle)),
// //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             flex: flexs[0],
// //             child: Align(
// //               alignment: Alignment.topLeft,
// //               child: Text(DateFormat('dd/MM/yyyy').format(t.dateTime), style: TextStyle(fontSize: size)),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[1],
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Container(
// //                   constraints: BoxConstraints(maxWidth: (context.page.pageFormat.width / sumFlexes) - 30),
// //                   child: Text(
// //                     (t.title * testRepeat).substring(0, (t.title * testRepeat).length > txtLen ? txtLen : (t.title * testRepeat).length),
// //                     style: TextStyle(fontSize: size),
// //                     maxLines: 1,
// //                     tightBounds: true,
// //                     softWrap: false,
// //                   ),
// //                 ),
// //                 Container(
// //                   // constraints: BoxConstraints(maxWidth: (context.page.pageFormat.width / sumFlexes) - 30),
// //                   width: (context.page.pageFormat.width / sumFlexes) - 30,
// //                   child: Text(
// //                     (t.remark * testRepeat).substring(0, (t.remark * testRepeat).length > txtLen ? txtLen : (t.remark * testRepeat).length),
// //                     style: TextStyle(fontSize: size),
// //                     maxLines: 1,
// //                     tightBounds: true,
// //                     softWrap: false,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[2],
// //             child: Align(
// //               alignment: Alignment.centerRight,
// //               child: FittedBox(
// //                 child: Container(
// //                   constraints: BoxConstraints(minWidth: 10, minHeight: 10),
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     t.isDebit ? '' : t.amount.toStringAsFixed(2),
// //                     textAlign: TextAlign.right,
// //                     style: TextStyle(fontSize: size),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[3],
// //             child: Align(
// //               alignment: Alignment.centerRight,
// //               child: FittedBox(
// //                 child: Container(
// //                   constraints: BoxConstraints(minWidth: 10, minHeight: 10),
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     !t.isDebit ? '' : t.amount.toStringAsFixed(2),
// //                     textAlign: TextAlign.right,
// //                     style: TextStyle(fontSize: size),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[4],
// //             child: Align(
// //               alignment: Alignment.centerRight,
// //               child: FittedBox(
// //                 child: Container(
// //                   constraints: BoxConstraints(minWidth: 10, minHeight: 10),
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     t.absoluteBalance.toStringAsFixed(2) + ' ' + (t.balance < 0 ? 'Dr' : 'Cr'),
// //                     textAlign: TextAlign.right,
// //                     style: TextStyle(fontSize: size, fontWeight: t.balance < 0 ? FontWeight.bold : null),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _HeadingRow extends StatelessWidget {
// //   @override
// //   Widget build(Context context) {
// //     double size = 12;
// //     final bstyle = BorderSide(style: BorderStyle.solid, color: PdfColors.black, width: 1);
// //     return Container(
// //       decoration: BoxDecoration(border: Border(top: bstyle, bottom: bstyle, right: bstyle, left: bstyle)),
// //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             flex: flexs[0],
// //             child: Center(
// //               child: Text('Date', style: TextStyle(fontSize: size)),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[1],
// //             child: Center(
// //               child: Text('Particulars', style: TextStyle(fontSize: size)),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[2],
// //             child: Align(
// //               alignment: Alignment.center,
// //               child: Text(
// //                 'Credit',
// //                 style: TextStyle(fontSize: size),
// //               ),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[3],
// //             child: Align(
// //               alignment: Alignment.center,
// //               child: Text(
// //                 'Debit',
// //                 style: TextStyle(fontSize: size),
// //               ),
// //             ),
// //           ),
// //           _Sep(),
// //           Expanded(
// //             flex: flexs[4],
// //             child: Align(
// //               alignment: Alignment.center,
// //               child: Text(
// //                 'Balance',
// //                 textAlign: TextAlign.right,
// //                 style: TextStyle(fontSize: size),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _Sep extends StatelessWidget {
// //   @override
// //   Widget build(Context context) {
// //     return Container(margin: EdgeInsets.symmetric(horizontal: 5), width: 1, color: PdfColors.grey, height: 30);
// //   }
// // }
