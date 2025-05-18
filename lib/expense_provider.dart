import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _expenses = [];

  List<Map<String, dynamic>> get expenses => _expenses;

  void addExpense({required String description, required double amount, required String date}) {
    _expenses.add({
      'description': description,
      'amount': amount,
      'date': date,
    });
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
                      description: desc,
                      amount: amount,
                      date: DateFormat('dd/MM/yy').format(selectedDate),
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
