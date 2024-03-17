import 'package:flutter/material.dart';
import 'package:money_manager/models/category/category_popup.dart';
import 'package:money_manager/screens/category/screen_categories.dart';
import 'package:money_manager/screens/transactions/add_transaction.dart';
import 'package:money_manager/screens/transactions/screen_transactions.dart';



class Home extends StatelessWidget {

 const Home({super.key});

  static final ValueNotifier<int> currentIndexNotifier = ValueNotifier(0);
  final _listScreens = const [Transactions(), Categories()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Money Manager"),
        centerTitle: true,
        backgroundColor:Colors.blue,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
            valueListenable: currentIndexNotifier,
            builder: (context, value, child) {
              return _listScreens[value];
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(currentIndexNotifier.value == 0){
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          }
          else{
            openDialog(context);
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ValueListenableBuilder(
        valueListenable: currentIndexNotifier,
        builder: (context, value, child) {
          return (BottomNavigationBar(
            onTap: (index) {
              currentIndexNotifier.value = index;
            },
            currentIndex: currentIndexNotifier.value,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: "Category"),
            ],
          ));
        });
  }
}
