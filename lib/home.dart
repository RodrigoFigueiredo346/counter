import 'package:counter/expense_provider.dart';
import 'package:counter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  ExpensesPage({super.key});
  late ExpenseProvider expenseProvider;

  String _getMonthAbbreviation(int month) {
    const monthNames = ['JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    expenseProvider = Provider.of<ExpenseProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue, // Fundo da tela
        body: Column(
          children: [
            _buildHeader(),
            _buildSelectorYear(),
            _buildMonthSelector(),
            Expanded(child: _buildExpenseList(expenseProvider.filteredExpenses)),
            _buildTotal(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddExpenseDialog(context);
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 48,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Counter',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Olá',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 32),
                onPressed: () {
                  // Ação para perfil
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelectorYear() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => expenseProvider.setSelectedYear(expenseProvider.selectedYear - 1),
        ),
        Text(
          '${expenseProvider.selectedYear}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => expenseProvider.setSelectedYear(expenseProvider.selectedYear + 1),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final currentMonth = expenseProvider.selectedMonth;
    final currentYear = expenseProvider.selectedYear;

    final months = List.generate(12, (i) {
      final date = DateTime(currentYear, i + 1);
      final monthAbbr = _getMonthAbbreviation(date.month);
      return {'label': monthAbbr, 'month': date.month};
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: months.map((entry) {
          final isActive = currentMonth == entry['month'];
          return GestureDetector(
            onTap: () => expenseProvider.setSelectedMonth(entry['month'] as int),
            child: Text(
              '${entry['label']}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: isActive ? 18 : 12,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseList(List<ExpenseModel> expenses) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: Colors.white,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: expenseProvider.filteredExpenses.length,
        itemBuilder: (context, index) {
          final expense = expenseProvider.filteredExpenses[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(expense.description, style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              Text(expense.formattedDate, style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              Text(expense.formattedAmount, style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              IconButton(
                onPressed: () {
                  expenseProvider.deleteExpense(expense);
                },
                icon: const Icon(Icons.delete, color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      padding: const EdgeInsets.only(bottom: 100.0, right: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Total        R\$ ${expenseProvider.totalFiltered.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
