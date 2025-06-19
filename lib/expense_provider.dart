import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  final Box<ExpenseModel> _box = Hive.box<ExpenseModel>('expenses');

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  void setSelectedMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void setSelectedYear(int year) {
    if (year > 2009 && year < DateTime.now().year + 11) {
      _selectedYear = year;
    }
    notifyListeners();
  }

  List<ExpenseModel> get expenses => _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));

  List<ExpenseModel> get filteredExpenses => expenses.where((e) => e.date.month == _selectedMonth && e.date.year == _selectedYear).toList();

  double get totalFiltered => filteredExpenses.fold(0, (sum, e) => sum + e.amount);

  void addExpense(ExpenseModel expense) {
    _box.add(expense);
    notifyListeners();
  }

  void deleteExpense(ExpenseModel expense) {
    final key = _box.keyAt(_box.values.toList().indexOf(expense));
    _box.delete(key);
    notifyListeners();
  }
}

void showAddExpenseDialog(BuildContext context) {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Adicionar Gasto'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Valor'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Data: ${DateFormat('dd/MM/yy').format(selectedDate)}',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final desc = descriptionController.text.trim();
                  final amount = double.tryParse(amountController.text.trim().replaceAll(',', '.'));

                  if (desc.isNotEmpty && amount != null) {
                    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
                      ExpenseModel(
                        description: desc,
                        amount: amount,
                        date: selectedDate,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    },
  );
}
