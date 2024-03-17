// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/categories_model.dart';

const categoryDBName = 'category-database';

abstract class CategoryDbFunctions{
 Future<List<CategoryModel>> getAllCategories();
 Future<void> addCategory(CategoryModel category);
 Future<void> deleteCategory(String categoryID);
}

class CategoryDb implements CategoryDbFunctions {

  //singleton object
  CategoryDb._internal(); //named constructor
  static CategoryDb instance = CategoryDb._internal();
  factory CategoryDb(){
    return instance;
  }


  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);


//Add Data
  @override
  Future<void> addCategory(CategoryModel category) async{
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
    categoryDB.put(category.id,category);
    refreshUI();
  }
  


//Get data
  @override
  Future<List<CategoryModel>> getAllCategories() async{
        final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
        return categoryDB.values.toList();
  }

  Future<void> refreshUI() async{
    final allCategories = await getAllCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();
    await Future.forEach(allCategories, (element) {
        if(element.category == CategoryType.income)
        {
          incomeCategoryList.value.add(element);
        }
        else{
          expenseCategoryList.value.add(element);
        }
    });
      incomeCategoryList.notifyListeners();
      expenseCategoryList.notifyListeners();
  }
  

  //Delete data
  @override
  Future<void> deleteCategory(String categoryID) async{
      final categoryDB = await Hive.openBox<CategoryModel>(categoryDBName);
      await categoryDB.delete(categoryID);
      refreshUI();
  }
}

