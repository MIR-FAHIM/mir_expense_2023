import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_expense/provider/provider_manager.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_expense.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_income.dart';
import 'package:project_expense/screen/wallet/walletview.dart';
import 'package:provider/provider.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _HomePageState();
}

class _HomePageState extends State<AddTransaction> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Consumer<LangProvider>(
        builder: (context, provider, widget) {
          return Scaffold(

            appBar: AppBar(
              backgroundColor: Colors.green,
              title: provider.bangLang ==true ? Text("নতুন আয়/ব্যয় যুক্ত  করুন") : Text("Add Transaction"),
            ),


            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: TabBar(
                      labelColor: Colors.lightGreen,
                      tabs: [
                        Tab(
                          text: provider.bangLang ==true ? "ব্যয়" :"Expense",

                        ),
                        Tab(
                          text: provider.bangLang ==true ? "আয়" :"Income",

                        ),

                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: TabBarView(
                      children: [
                        AddExpense(),
                        AddIncome(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
