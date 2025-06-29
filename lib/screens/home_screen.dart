import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/expense_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final today = DateTime.now();
    final expensesToday = provider.getExpensesByDate(today);
    final total = provider.getTotalByDate(today);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset(
            //   'assets/icon/M-Money_Logo_40x40-removebg-preview.png',
            //   height: 30,
            // ),
            SizedBox(width: 10),
            Text('M-Money'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Tanggal: ${DateFormat('dd MMM yyyy').format(today)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Total Pengeluaran: Rp ${total.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(child: ExpenseList(expenses: expensesToday)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => AddExpenseDialog()),
        child: Icon(Icons.add),
      ),
    );
  }
}
