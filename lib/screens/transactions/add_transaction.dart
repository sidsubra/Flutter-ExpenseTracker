// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/categories_model.dart';
//for date time formatting, line 59
import 'package:intl/intl.dart';
import 'package:money_manager/models/transactions/transactions_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  const ScreenAddTransaction({super.key});
  static const routeName = 'add-transaction';

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {

  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType = CategoryType.income;
  CategoryModel? _selectedCategoryModel;

  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
              child: Column(children: [
            //Purpose
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  hintText: "Purpose", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            //Amount
            TextFormField(
              controller: _amountEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Amount", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            //Calendar
            TextButton.icon(
                onPressed: () async{
                  final selectedDateTemp = await showDatePicker(
                    initialDate: DateTime.now(),
                    context: context,
                    firstDate: DateTime.now().subtract(const Duration(days:60)),
                    lastDate: DateTime.now()
                    );
                  if(selectedDateTemp == null){
                    return;
                  }else{
                    setState(() {
                      _selectedDate = selectedDateTemp;
                    });
                  }
                   },
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(_selectedDate == null? 'Select Date':DateFormat('dd-MMM-yyyy').format(_selectedDate!))),
                const SizedBox(height: 10),
            //Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(value: CategoryType.income, groupValue: _selectedCategoryType, onChanged: (newValue){
                        setState(() {
                          _categoryID = null;
                          _selectedCategoryType = newValue;
                        });
                    }),
                    const Text('Income')
                  ],
                ),
                Row(
              children: [
                Radio(value: CategoryType.expense, groupValue: _selectedCategoryType, onChanged: (newValue){
                    setState(() {
                          _categoryID = null;
                          _selectedCategoryType = newValue;
                    });
                }),
                const Text('Expense')
              ],
            )
              ],
            ),
            const SizedBox(height: 10),
            //Category Type
            DropdownButton(
              value: _categoryID,
              hint: const Text('Select Type'),
              items: (_selectedCategoryType == CategoryType.income?CategoryDb.instance.incomeCategoryList:CategoryDb.instance.expenseCategoryList).value.map((e) {
                return  DropdownMenuItem(
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
                  value: e.id,
                  child: Text(e.name));
              }).toList()
             ,
              onChanged: (selectedValue){
                setState(() {
                  _categoryID = selectedValue;
                });
              }),
        //Add Button
        const SizedBox(height: 10),
        ElevatedButton(onPressed: (){
          addTransaction();
        }, child: const Text("Add"))
        ])),
        ),
      ),
    ));
  }
  
  Future<void> addTransaction() async{
    final purposeText = _purposeTextEditingController.text;
    final amountText = _amountEditingController.text;

    if(purposeText.isEmpty){
      return;
    }
    else if(amountText.isEmpty){
      return;
    }
    else if(_categoryID == null){
      return;
    }
    else if(_selectedDate == null){
      return;
    }

    final parsedAmt = double.tryParse(amountText);
    if(parsedAmt == null){
      return;
    }
    final model =  TransactionModel(
      purpose: purposeText, 
      amount: parsedAmt, 
      date: _selectedDate!, 
      categoryType: _selectedCategoryType!, 
      category: _selectedCategoryModel!
      );

        //Adding model to hive
      await TransactionDbFunctions.instance.addTransaction(model);
      Navigator.of(context).pop();

  }
  
}
