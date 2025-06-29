import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseDialog extends StatefulWidget {
  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _amount = '';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      provider.addExpense(
        Expense(
          id: Uuid().v4(),
          title: _title,
          amount: double.parse(_amount),
          date: DateTime.now(),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Pengeluaran'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Deskripsi'),
              onSaved: (value) => _title = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Deskripsi harus diisi' : null,
            ),
            TextFormField(
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
