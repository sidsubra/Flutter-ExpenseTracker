import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/categories_model.dart';
import 'package:money_manager/models/transactions/transactions_model.dart';
import 'package:intl/intl.dart';

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    return (
      ValueListenableBuilder(valueListenable: TransactionDbFunctions.instance.transactionsList, builder: (ctx,transactionList,child){
        return (
      ListView.separated(
        itemBuilder: (BuildContext ctx, int index){
          TransactionModel transactionModel = transactionList[index];
          return  Slidable(
            key:Key(transactionModel.id!),
            startActionPane: ActionPane(motion: ScrollMotion(), children: [
              SlidableAction(onPressed: (ctx){
                TransactionDbFunctions.instance.deleteTransaction(transactionModel.id!);
              },
              icon: Icons.delete,
              label: 'Delete',
              )
            ]),
            child: Card(
              child: (
                 ListTile(
                  leading: CircleAvatar(
                    radius: 50, 
                    backgroundColor:transactionModel.categoryType == CategoryType.income?Colors.green:Colors.red,
                    foregroundColor: Colors.white,
                    child: Text(parseDate(transactionModel.date),textAlign: TextAlign.center),
                    ),
                  title: Text('${transactionModel.amount} INR'),
                  subtitle: Text(transactionModel.category.name),
                )
              ),
            ),
          );
        }, 
        separatorBuilder: (BuildContext ctx, int index){
          return const SizedBox(height: 5);
        },
         itemCount: transactionList.length)
        );
      })
    );
  }

  String parseDate(DateTime date){
    return '${date.day} \n ${DateFormat('MMM').format(date)}';
  }
}

