import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_expense/screen/home_page.dart';
import 'package:project_expense/screen/project/project_dashboard.dart';
import 'package:project_expense/screen/project/project_expense.dart';
import 'package:project_expense/screen/project/project_income.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_expense.dart';
import 'package:project_expense/screen/transaction/add_transaction/add_income.dart';
import 'package:project_expense/screen/wallet/walletview.dart';

class ProjectTransaction extends StatefulWidget {
  String? project;
  ProjectTransaction({required this.project});

  @override
  State<ProjectTransaction> createState() => _HomePageState();
}

class _HomePageState extends State<ProjectTransaction> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(

            builder: (BuildContext context) => ProjectDashBoard(),
          ),
              (route) => true,//if you want to disable back feature set to false
        );
        return false;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Project Transaction"),
            actions: [
              GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(

                        builder: (BuildContext context) => HomePage(1),
                      ),
                          (route) => true,//if you want to disable back feature set to false
                    );
                  },
                  child: Icon(Icons.home_outlined, color: Colors.white,)),
              SizedBox(width: 20,),
            ],
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
                        text: "Expense",

                      ),
                      Tab(
                        text: "Income",

                      ),

                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 160,
                  child: TabBarView(
                    children: [
                      ProjectExpenseListScreen(project:widget.project!),
                      ProjectIncomeListScreen(project:widget.project!),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
