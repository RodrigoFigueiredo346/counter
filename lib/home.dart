import 'package:counter/expense_provider.dart';
import 'package:counter/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  ExpensesPage({super.key});
  late ExpenseProvider expenseProvider;

  @override
  Widget build(BuildContext context) {
    expenseProvider = Provider.of<ExpenseProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue, // Fundo da tela
        body: Column(
          children: [
            _buildHeader(),
            _buildMonthSelector(),
            Expanded(child: _buildExpenseList()),
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
            'Meus gastos!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'R\$ 4600,00',
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

  Widget _buildMonthSelector() {
    final months = ['JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ', 'JAN'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: months.map((month) {
          final isActive = month == 'OUT';
          return Text(
            month,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: isActive ? 24 : 18,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseList() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Colors.white),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: expenseProvider.expenses.length,
        itemBuilder: (context, index) {
          final expense = expenseProvider.expenses[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expense.description,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              Text(
                expense.formattedDate,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              Text(
                expense.formattedAmount,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              IconButton(
                onPressed: () {
                  // Ação para deletar o item
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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '4500,00',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}
