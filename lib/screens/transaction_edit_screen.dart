import 'package:expense_planner_pro/models/transaction.dart';
import 'package:expense_planner_pro/services/local_db_service.dart';
import 'package:expense_planner_pro/utils/custom_input_decorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class TransactionEditScreen extends StatefulWidget {
  static const routeName = '/transaction-edit';

  @override
  _TransactionEditScreenState createState() => _TransactionEditScreenState();
}

class _TransactionEditScreenState extends State<TransactionEditScreen> {
  TransactionEntity t;

  TextEditingController _title = TextEditingController(), _remark = TextEditingController(), _amount = TextEditingController(), _dateTimeC = TextEditingController();
  bool _debit = false;
  DateTime _dateTime;

  final skey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        t = (ModalRoute.of(context).settings.arguments as TransactionEntity);
        if (t != null) {
          _title.text = t.title;
          _remark.text = t.remark;
          _amount.text = t.amount.toStringAsFixed(2);
          _dateTime = t.dateTime;
          _dateTimeC.text = DateFormat('dd/MM/yyyy').format(t.dateTime);
          _debit = t.isDebit;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: skey,
      appBar: AppBar(
        title: Text(t == null ? 'Add Transaction' : 'Edit Transaction'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_remark.text.isEmpty || _title.text.isEmpty || _dateTime == null || _amount.text.isEmpty || double.tryParse(_amount.text) == null) {
                skey.currentState
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('Some fields are missing!')));
                return;
              }
              if (t == null) {
                t = TransactionEntity(
                  id: null,
                  dateTime: _dateTime,
                  amount: double.parse(_amount.text),
                  title: _title.text,
                  isDebit: _debit,
                  remark: _remark.text,
                );
                await LocalDbService.insert(t);
              } else {
                t.dateTime = _dateTime;
                t.amount = double.parse(_amount.text);
                t.isDebit = _debit;
                t.title = _title.text;
                t.remark = _remark.text;
                await LocalDbService.update(t);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: _title,
            maxLines: 1,
            decoration: CustomInputDecorator.getStandardInputDecoration(context).copyWith(
              prefixIcon: Icon(Icons.short_text, color: Theme.of(context).primaryColor),
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _dateTimeC,
            maxLines: 1,
            readOnly: true,
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365 * 10)),
                lastDate: DateTime.now().add(Duration(days: 365 * 5)),
              );
              if (d != null) {
                setState(() {
                  _dateTime = d;
                  _dateTimeC.text = DateFormat('dd/MM/yyyy').format(d);
                });
              }
            },
            decoration: CustomInputDecorator.getStandardInputDecoration(context).copyWith(
              prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
              hintText: 'Click to choose date!',
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _amount,
            maxLines: 1,
            decoration: CustomInputDecorator.getStandardInputDecoration(context).copyWith(
              prefixIcon: Icon(FontAwesome.rupee, color: _debit ? Colors.red[700] : Theme.of(context).primaryColor),
              hintText: 'Amount',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
            textAlign: TextAlign.right,
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  value: true,
                  onChanged: (v) {
                    setState(() {
                      _debit = true;
                    });
                  },
                  title: Text('Debit'),
                  groupValue: _debit,
                ),
              ),
              Expanded(
                child: RadioListTile(
                  value: false,
                  onChanged: (v) {
                    setState(() {
                      _debit = false;
                    });
                  },
                  title: Text('Credit'),
                  groupValue: _debit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _remark,
            minLines: 1,
            maxLines: 3,
            decoration: CustomInputDecorator.getStandardInputDecoration(context).copyWith(
              prefixIcon: Icon(Icons.sort, color: Theme.of(context).primaryColor),
              hintText: 'Remarks',
            ),
          ),
        ],
      ),
    );
  }
}
