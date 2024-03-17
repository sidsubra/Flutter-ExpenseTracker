import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/categories_model.dart';

ValueNotifier<CategoryType> activeCategoryType = ValueNotifier(CategoryType.income);

Future<void> openDialog(BuildContext context) async {
  final categoryValueController = TextEditingController();

  showDialog(
      context: context,
      builder: (ctx) {
        return (SimpleDialog(
          title: const Text('Add Category'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: categoryValueController,
                decoration: const InputDecoration(
                    hintText: 'Category Name', border: OutlineInputBorder()),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  RadioButton(title: "Income", type: CategoryType.income),
                  RadioButton(title: "Expense", type: CategoryType.expense),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = categoryValueController.text.trim();
                  if(_name.isEmpty){
                    return;
                  }
                  final _type = activeCategoryType.value;
                  final _category = CategoryModel(id: DateTime.now().millisecondsSinceEpoch.toString(), name: _name, category: _type);

                 CategoryDb.instance.addCategory(_category);
                 Navigator.of(ctx).pop();
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: const Text('Add',style: TextStyle(color: Colors.white ),)),
            )
          ],
        ));
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return (ValueListenableBuilder(
        valueListenable: activeCategoryType,
        builder: ((BuildContext ctx, CategoryType value, Widget? _) {
          return (Row(children: [
            Radio<CategoryType>(
                value: type,
                groupValue:value, 
                onChanged: (CategoryType? value) {
                  if(value == null){
                    return ;
                  }
                  activeCategoryType.value = value;
                  activeCategoryType.notifyListeners();
                }),
            Text(title)
          ]));
        })));
  }
}
