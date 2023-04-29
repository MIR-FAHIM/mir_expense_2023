import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_expense/screen/chart/line_chart.dart';




class ExpenseChartTime extends StatefulWidget {


  @override
  State<ExpenseChartTime> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<ExpenseChartTime> {

  TextEditingController searchController = TextEditingController();
  bool department = true;
  List transactionList = [];
  CollectionReference trainCanteen =
  FirebaseFirestore.instance.collection('project_expense');
  Future getExpense() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("transaction")
        .get();

    // Get data from docs and convert map to List
    transactionList = querySnapshot.docs.where((element) => element["type"] == "expense"  ).map((doc) => doc.data()).toList();


    print("get all data ${transactionList.length} ");
    return transactionList;
  }
  bool searchStart = false;
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.green,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor:  Colors.green,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(



      body:

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [

            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getExpense(),
              builder: (BuildContext context, snapshot) {
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
                      return Container(
                        height: MediaQuery.of(context).size.height * 1.3,
                        child:  Column(
                          children: <Widget>[

                            Expanded(
                              child: SingleChildScrollView(
                                child: LineChartSample1(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ]),
        ),
      ),



    );
  }




}





