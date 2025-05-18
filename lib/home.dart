import 'package:counter/add_expense.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    final months = ['JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ', 'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN'];

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
    final expenses = List.generate(10, (index) {
      return {
        'date': '26/09',
        'description': 'açaí',
        'amount': '15,00',
      };
    });

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Colors.white),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    expense['date']!,
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    expense['description']!,
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expense['amount']!,
                    style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      // Ação para deletar o item
                    },
                    icon: const Icon(Icons.delete, color: Colors.grey),
                  ),
                ],
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
