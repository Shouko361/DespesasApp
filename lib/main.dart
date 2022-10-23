import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'components/chart.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(List<String> args) {
  runApp(const DespesaApp());
}

class DespesaApp extends StatelessWidget {
  const DespesaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: themeData.copyWith(
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.purple,
        ),
        textTheme: themeData.textTheme.copyWith(
          headline6: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(
      () {
        _transaction.add(newTransaction);
      },
    );

    Navigator.of(context).pop();
  }

  _delTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionForm(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TransactionForm(_addTransaction),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Center(
        child: Text('Minhas Despesas'),
      ),
      actions: [
        if (isLandScape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.bar_chart_outlined),
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionForm(context),
        ),
      ],
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _openTransactionForm(context),
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_showChart || !isLandScape)
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child: const Text(
                      'Grafico Semanal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: availableHeight * (isLandScape ? 0.7 : 0.25),
                    child: Chart(_recentTransactions),
                  ),
                ],
              ),
            if (!_showChart || !isLandScape)
              Container(
                height: availableHeight * (isLandScape ? 1 : 0.70),
                child: TransactionList(_transaction, _delTransaction),
              ),
          ],
        ),
      ),
    );
  }
}
