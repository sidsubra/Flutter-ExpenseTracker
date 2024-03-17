import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/transactions/transactions_model.dart';


const transactionDbName = 'transaction-database';

abstract class TransactionDbAbstractFunctions{
  Future<void> addTransaction(TransactionModel transactionModel);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDbFunctions implements TransactionDbAbstractFunctions{

  TransactionDbFunctions._internal();
  static TransactionDbFunctions instance =  TransactionDbFunctions._internal();
  factory TransactionDbFunctions(){
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionsList = ValueNotifier([]);

  //Add a transaction
  @override
  Future<void> addTransaction(TransactionModel transactionModel) async{
    final transactionDb = await Hive.openBox<TransactionModel>(transactionDbName);
    transactionDb.put(transactionModel.id, transactionModel);
    refreshUI();
  }

  //Get all transactions
  @override
  Future<List<TransactionModel>> getAllTransactions() async{
    final transactionDb = await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDb.values.toList();
  }

  Future<void> refreshUI() async{
    final allTransactions = await getAllTransactions();
    allTransactions.sort((first,second)=> second.date.compareTo(first.date));
    transactionsList.value.clear();
    transactionsList.value.addAll(allTransactions);
    transactionsList.notifyListeners();
  }
  
  //delete transaction
  @override
  Future<void> deleteTransaction(String id) async{
    final transactionDb = await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDb.delete(id);
    refreshUI();
  }

}