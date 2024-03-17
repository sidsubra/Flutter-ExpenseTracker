import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/categories_model.dart';

class IncomeCategories extends StatelessWidget {
  const IncomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return (
      ValueListenableBuilder(valueListenable: CategoryDb.instance.incomeCategoryList, builder: (BuildContext ctx,List<CategoryModel> incomeList,Widget? _) {
        return(
          Padding(
                padding: const EdgeInsets.all(8.0),
                child: (
                  ListView.separated(
                    itemBuilder:(context, index){
                      final category = incomeList[index];
                      return Card(
                        child: (
                          ListTile(
                            title: Text(category.name),
                            trailing: IconButton(icon: const Icon(Icons.delete_outline_sharp),onPressed: (){
                              CategoryDb.instance.deleteCategory(category.id);
                            })
                          )
                        ),
                      );
                    }, 
                    separatorBuilder: (context, index){
                      return const SizedBox(height: 10);
                    }, 
                    itemCount: incomeList.length)
                ),
              )
        );
      })
    );
  }
}