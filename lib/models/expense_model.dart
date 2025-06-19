import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0)
class ExpenseModel {
  @HiveField(0)
  String description;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  ExpenseModel({
    required this.description,
    required this.amount,
    required this.date,
  });

  String get formattedDate => DateFormat('dd/MM').format(date);

  String get formattedAmount => 'R\$ ${amount.toStringAsFixed(2)}';
}
