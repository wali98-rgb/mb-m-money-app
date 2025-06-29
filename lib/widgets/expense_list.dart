import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:m_money/providers/expense_provider.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import 'edit_expense_dialog.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(child: Text('Belum ada pengeluaran.'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, i) {
        final e = expenses[i];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                'Rp',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            title: Text(
              'Rp ${e.amount.toStringAsFixed(0)} untuk ${e.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Waktu: ${DateFormat('dd MMM yyyy – HH:mm').format(e.date)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => EditExpenseDialog(expense: e),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, e.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Pengeluaran?'),
        content: Text('Apakah kamu yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ExpenseProvider>(
                context,
                listen: false,
              ).deleteExpense(id);
              Navigator.of(context).pop();
            },
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
