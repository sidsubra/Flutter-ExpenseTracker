import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/categories_model.dart';
part 'transactions_model.g.dart';

@HiveType(typeId: 3) 
class TransactionModel{

  @HiveField(0)
  String? id;

  @HiveField(1)
  final String purpose;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date; 

  @HiveField(4)
  final CategoryType categoryType;

  @HiveField(5)
  final CategoryModel category;

  TransactionModel({
    required this.purpose, 
    required this.amount,
    required this.date,
    required this.categoryType, 
    required this.category,
    })
    {
      id =  DateTime.now().millisecondsSinceEpoch.toString();
    }
}