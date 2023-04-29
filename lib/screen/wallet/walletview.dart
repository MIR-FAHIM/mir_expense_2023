import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_expense/provider/provider_manager.dart';
import 'package:project_expense/screen/chart/expense_time.dart';
import 'package:project_expense/screen/chart/fl_chart_expense.dart';
import 'package:project_expense/screen/chart/line_chart.dart';
import 'package:project_expense/screen/contact/contactList.dart';
import 'package:project_expense/screen/project/project_dashboard.dart';
import 'package:project_expense/screen/setting/setting_page.dart';
import 'package:project_expense/screen/transaction/donation/donation.dart';
import 'package:project_expense/screen/wallet/constant.dart';
import 'package:provider/provider.dart';



class Ewallet extends StatefulWidget {
  @override
  State<Ewallet> createState() => _EwalletState();
}

class _EwalletState extends State<Ewallet> {
  CollectionReference trainCanteen =
  FirebaseFirestore.instance.collection('project_expense');
  List expenseData = [];
  List incomeData = [];

  @override
  Widget build(BuildContext context) {

    return Consumer<LangProvider>(
      builder: (context, provider, widget) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: true,
            title: provider.bangLang == true ?Text("হোম") :Text("Home"),
            actions: [
              Switch.adaptive(
                value: provider.bangLang,
                onChanged: (value) {
                  Provider.of<LangProvider>(context, listen: false).changeLang(
                      value);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: <Widget>[



                            _buildGradientBalanceCard(),

                            SizedBox(height: 24.0),

                            _buildCategories(),
                            SizedBox(height: 15.0),
                            Container(
                              height: 240,
                              child: FutureBuilder(
                                future: getCat(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == null) {
                                    print("no data found");
                                  } else {}

                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Text("waiting");
                                    default:
                                      if (snapshot.hasError)
                                        return Center(child: Text('No Data Found'));
                                      if (snapshot.data == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Column(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                     provider.bangLang == true ?Text("ক্যাটাগরি",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),) : Text("Category",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                      Text("(Expense)",style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),

                                                    ],
                                                  ),
                                                  provider.bangLang == true ?Text("এমাউন্ট",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),) :Text("Amount",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 200,


                                              child: ListView.builder(
                                                itemCount: catData.length,
                                                itemBuilder: (BuildContext context, index){
                                                  return Card(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        height: 40,
                                                        width: MediaQuery.of(context).size.width,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(catData[index]["cat_name"]),
                                                            Text(expenseData.where((element) => element["category"] == catData[index]["cat_name"])
                                                                .fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])).toString()),
                                                          ],
                                                        ),


                                                      ),
                                                    ),
                                                  );
                                                },

                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                  }
                                },
                              ),
                            ),




                          ],
                        ),
                      ),


                     SizedBox(height: 10),

                      Container(
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width,
                        child: Expanded(
                          child: BarChartSample2(),
                        ),
                      ),

                 //     _buildTransactionList(),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Padding _buildTableExpense() {
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),

      child: Table(
          border: TableBorder.all(width: 1.0, color: Colors.black),
          children: [
            for (var video in expenseData) TableRow(children: [
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(video["category"]),
                    Text(video["amount"]),
                  ],
                ),
              )
            ])
          ]
      ),
    );
  }


  Container _buildCategories() {
    return Container(
      child: Consumer<LangProvider>(
        builder: (context, provider,widget ) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(

                      builder: (BuildContext context) => ContactList(),
                    ),
                        (route) => true,//if you want to disable back feature set to false
                  );
                },
                child: _buildCategoryCard(
                  bgColor: Constants.sendBackgroundColor,
                  iconColor: Constants.sendIconColor,
                  iconData: Icons.send,
                  text: provider.bangLang == true? "কন্টাক্ট": "Contacts",
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(

                      builder: (BuildContext context) => ProjectDashBoard(),
                    ),
                        (route) => true,//if you want to disable back feature set to false
                  );

                },
                child: _buildCategoryCard(
                  bgColor: Constants.activitiesBackgroundColor,
                  iconColor: Constants.activitiesIconColor,
                  iconData: Icons.work,
                  text:provider.bangLang == true? "প্রজেক্ট": "Projects",
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(

                      builder: (BuildContext context) => SettingPage(),
                    ),
                        (route) => true,//if you want to disable back feature set to false
                  );
                },
                child: _buildCategoryCard(
                  bgColor: Constants.statsBackgroundColor,
                  iconColor: Constants.statsIconColor,
                  iconData: Icons.trending_up,
                  text:provider.bangLang == true? "সেটিং": "Settings",
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(

                      builder: (BuildContext context) => DonationList(),
                    ),
                        (route) => true,//if you want to disable back feature set to false
                  );
                },
                child: _buildCategoryCard(
                  bgColor: Constants.paymentBackgroundColor,
                  iconColor: Constants.paymentIconColor,
                  iconData: Icons.payment,
                  text: provider.bangLang == true? "ডোনেশন ": "Donation",
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Container _buildGradientBalanceCard() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.greenAccent.withOpacity(0.9),
            Constants.deepBlue,
          ],
        ),
      ),
      child:      FutureBuilder(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            print("no data found");
          } else {}

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Center(child: Text('No Data Found'));
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Consumer<LangProvider>(
                  builder: (context, provider, widget) {
                    return Container(
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "\$${totalIncome-totalExpense}",
                                        style: TextStyle(
                                          color: totalIncome-totalExpense < 0 ?Colors.red : Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                     provider.bangLang == true ? Text(
                                       "মোট ব্যালান্স",
                                       style: TextStyle(
                                         color: Colors.white.withOpacity(0.9),
                                         fontSize: 18,
                                       ),
                                     ): Text(
                                        "Total Balance",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      provider.bangLang == true ?Text(
                                      "মোট খরচ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 18,
                              ),
                            ) : Text(
                                        "Total Expense",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      provider.bangLang == true ? Text(
                                        "\$$totalExpense",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ):Text(
                                        "\$$totalExpense",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      provider.bangLang == true ? Text(
                                        "মোট ইনকাম",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 18,
                                        ),
                                      ):Text(
                                        "Total Income",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "\$$totalIncome",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),


                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              }
          }
        },
      ),

    );
  }

  Row _buildTransactionItem(
      {required Color color,
        required IconData iconData,
        required String date,
        required String title,
        required double amount}) {
    return Row(
      children: <Widget>[
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
        Spacer(),
        Text(
          "-\$ $amount",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column _buildCategoryCard(
      {required Color bgColor, required Color iconColor, required IconData iconData, required String text}) {
    return Column(
      children: <Widget>[

        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 36,
          ),
        ),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
  List catData = [];
  double totalExpense = 0.0 ;
  double totalIncome = 0.0 ;
  Future getData() async {
    expenseData.clear();
    incomeData.clear();
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("transaction")
        .get();

    // Get data from docs and convert map to List
    expenseData = querySnapshot.docs.where((element) => element["type"] == "expense").map((doc) => doc.data()).toList();
   print("expense data list is ${expenseData.length}");
    totalExpense = expenseData.fold(0, (previousValue, element) => previousValue + double.parse(element["amount"]));

    incomeData = querySnapshot.docs.where((element) => element["type"] == "income").map((doc) => doc.data()).toList();
    print("income data list is ${expenseData.length}");
    totalIncome = incomeData.fold(0, (previousValue, element) => previousValue + double.parse(element["amount"]));
    


    print("get all data ${expenseData.length} ");
    return expenseData;
  }
  Future getCat() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("cat_expense")
        .get();

    // Get data from docs and convert map to List
    catData = querySnapshot.docs.map((doc) => doc.data()).toList();


    print("get all data ${catData.length} ");
    return catData;
  }
}






