import 'package:flutter/material.dart';
import 'package:money_manager/screens/category/expense_categories.dart';
import 'package:money_manager/screens/category/income_categories.dart';

//Tab bar needs to be in a stateful widget
class Categories extends StatefulWidget {
  const Categories({super.key});
  @override
  State<Categories> createState() => _CategoriesState();
}

//SingleTickerProviderStateMixin is a mixin that is used for vsync in tabController
class _CategoriesState extends State<Categories> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
     super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return (
       Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
            Tab(text: "Income"),
            Tab(text: "Expense")
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                IncomeCategories(),
                ExpenseCategories()
            ]),
          )
        ],
      )
    );
  }
}