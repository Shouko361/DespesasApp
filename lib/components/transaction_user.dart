import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_list.dart';
import './transaction_form.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({Key? key}) : super(key: key);

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transaction = [
    Transaction(
      id: 't1',
      title: 'Compra Supermercado',
      value: 35.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Padaria',
      value: 60.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Adega',
      value: 22.0,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Shopping',
      value: 350.0,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TransactionList(
          _transaction,
        ),
        TransactionForm()
      ],
    );
  }
}
