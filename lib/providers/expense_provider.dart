import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expense => _expenses;

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('expenses');

    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      _expenses = decoded.map((e) => Expense.fromMap(e)).toList();
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await saveExpenses();
    notifyListeners();
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_expenses.map((e) => e.toMap()).toList());
    prefs.setString('expenses', data);
  }

  List<Expense> getExpensesByDate(DateTime date) {
    return _expenses
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }

  double getTotalByDate(DateTime date) {
    return getExpensesByDate(date).fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> updateExpense(Expense updated) async {
    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _expenses[index] = updated;
      await saveExpenses();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await saveExpenses();
    notifyListeners();
  }
}
