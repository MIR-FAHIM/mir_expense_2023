import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_expense/provider/provider_manager.dart';
import 'package:project_expense/screen/transaction/expense_list.dart';
import 'package:project_expense/screen/transaction/income_list.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_expense.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_transaction.dart';
import 'package:project_expense/screen/wallet/walletview.dart';
import 'package:provider/provider.dart';
import 'package:new_version_plus/new_version_plus.dart';

class HomePage extends StatefulWidget {
  int index = 1;
  HomePage( this.index);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  advancedStatusCheck() async {

    final newVersion = NewVersionPlus(
      //iOSId: 'com.google.Vespa',
      androidId: 'com.example.project_expense',
    );
    var status = await newVersion.getVersionStatus();
    print("version status ${status!.appStoreLink}");
    if (status.canUpdate == true) {
      newVersion.showUpdateDialog(
        //launchMode: LaunchMode.externalApplication,
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Available!',
        dialogText:
        'Upgrade Salebee ${status.localVersion} to Salebee ${status.storeVersion}',
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    advancedStatusCheck();
    return DefaultTabController(
      initialIndex: widget.index,
      length: 3,
      child: Consumer<LangProvider>(
        builder: (context, provider, widget) {
          return Scaffold(

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AddTransaction()),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            bottomNavigationBar: Container(
              color: Colors.green,
              child: TabBar(

                labelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: provider.bangLang == true ? "খরচ": "Expense",

                    ),
                    Tab(
                      text:  provider.bangLang == true ? "হোম":"Home",
                    ),
                    Tab(
                      text:  provider.bangLang == true ? "ইনকাম":"Income",
                    ),
                  ],
                ),
            ),

            body: TabBarView(
              children: [
                ExpenseListScreen(),
                Ewallet(),
                IncomeListScreen(),
              ],
            ),
          );
        }
      ),
    );
  }
}
