import 'package:hive_flutter/hive_flutter.dart';
part 'categories_model.g.dart';

//Similar to dropdown
//Enum needs to be treated as seperate table
@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense
}

@HiveType(typeId: 1)
class CategoryModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CategoryType category;

  @HiveField(3)
  final bool isDeleted;

  CategoryModel({required this.id,required this.name, required this.category,this.isDeleted = false});
}