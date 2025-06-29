import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;

  EditExpenseDialog({required this.expense});

  @override
  _EditExpenseDialogState createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _amount;

  @override
  void initState() {
    _title = widget.expense.title;
    _amount = widget.expense.amount.toString();
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updated = Expense(
        id: widget.expense.id,
        title: _title,
        amount: double.parse(_amount),
        date: widget.expense.date,
      );
      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      ).updateExpense(updated);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Pengeluaran'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Deskripsi'),
              onSaved: (value) => _title = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Deskripsi harus diisi' : null,
            ),
            TextFormField(
              initialValue: _amount,
              decoration: InputDecoration(labelText: 'Jumlah (Rp)'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _amount = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah harus diisi';
                }
                if (double.tryParse(value) == null) {
                  return 'Harus angka';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Batal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(child: Text('Simpan'), onPressed: _submit),
      ],
    );
  }
}
