import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/categories_model.dart';
import 'package:money_manager/models/transactions/transactions_model.dart';
import 'package:money_manager/screens/transactions/add_transaction.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  if(!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
    Hive.registerAdapter(CategoryModelAdapter());
  }

  if(!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
    Hive.registerAdapter(TransactionModelAdapter());
  }
  //Initial fetch and load data from Hive

  await TransactionDbFunctions.instance.refreshUI();
  await CategoryDb.instance.refreshUI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const Home(),
      debugShowCheckedModeBanner: false,
      routes: {
        ScreenAddTransaction.routeName: (ctx) => ScreenAddTransaction(),
      },
    );
  }
}