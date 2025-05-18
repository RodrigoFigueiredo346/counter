import 'package:intl/intl.dart';

class ExpenseModel {
  final String description;
  final double amount;
  final DateTime date;

  ExpenseModel({
    required this.description,
    required this.amount,
    required this.date,
  });

  String get formattedDate => DateFormat('dd/MM/yy').format(date);

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
}
