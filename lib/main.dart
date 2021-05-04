import 'package:expense_planner_pro/screens/generated_reports.dart';
import 'package:expense_planner_pro/screens/home_screen.dart';
import 'package:expense_planner_pro/screens/transaction_edit_screen.dart';
import 'package:expense_planner_pro/screens/transaction_view_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

String get version => '1.0.0';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.indigo,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => HomeScreen(),
        TransactionEditScreen.routeName: (_) => TransactionEditScreen(),
        TransactionViewScreen.routeName: (_) => TransactionViewScreen(),
        GeneratedReports.routeName: (_) => GeneratedReports(),
      },
    );
  }
}
