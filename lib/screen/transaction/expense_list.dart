import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_expense/const/static.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  CollectionReference trainCanteen =
  FirebaseFirestore.instance.collection('project_expense');
  List<String> yearList = <String>[DateTime.now().year.toString(), DateTime(DateTime.now().year-1).toString().substring(0,4), DateTime(DateTime.now().year-2).toString().substring(0,4) ];


  int yearSelection = int.parse(DateTime.now().toString().substring(0,4));



  int monthSelection = int.parse(DateTime.now().toString().substring(5, 7));
  int daySelection = int.parse(DateTime.now().toString().substring(8, 10));
  List<String> tabs = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<int> dayTab = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];
  String dropdownValue = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Expense List"),
      ),
      body:  Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: ListView(
          children: <Widget>[
            DefaultTabController(
              initialIndex: monthSelection - 1,
              length: 12,
              child: Container(
                height: 30,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        width: 70,
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          isExpanded: true,
                          icon: Icon(Icons
                              .arrow_drop_down_outlined),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors
                                  .deepPurple),
                          underline:
                          Container(
                            height: 2,
                            color: Colors
                                .transparent,
                          ),

                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                              yearSelection = int.parse(dropdownValue);
                            });
                          },
                          items: yearList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width - 150,

                      child: DefaultTabController(
                        initialIndex: monthSelection -1,
                        length: 12,
                        child: TabBar(


                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green),
                          isScrollable: true,
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,


                          onTap: (index){
                            setState((){
                              monthSelection = index+1;
                            });

                          },
                          tabs: tabs
                              .map((tab) => Tab(
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(tab,style: TextStyle(fontSize: 12),),
                            ),
                          ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: DefaultTabController(
                initialIndex: daySelection - 1,
                length: 31,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.black38,
                      labelColor: Colors.black,
                      onTap: (index) {
                        setState(() {
                          daySelection = index + 1;
                        });
                      },
                      tabs: dayTab
                          .map((tab) => Tab(
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tab.toString(),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[




                  FutureBuilder(
                    future: getExpense(),
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
                            return Column(
                              children: [
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Total Expense:", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),),
                                    Text(transactionList.fold(0, (previousValue, element)
                                    =>previousValue + int.parse(element["amount"])).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Container(
                                    height: MediaQuery.of(context).size.height,

                                    child:  ListView.builder(

                                        itemCount: transactionList.length,
                                        itemBuilder: (BuildContext context, index){
                                          return  GestureDetector(
                                            onTap: (){
                                              _showMyDialog();
                                            },
                                            child: Card(
                                              child: _buildTransactionItem(
                                                user: transactionList[index]["user"],
                                                des: transactionList[index]["des"],
                                                cat: transactionList[index]["category"],
                                                project: transactionList[index]["project"],
                                                color: Colors.deepPurpleAccent,
                                                iconData: Icons.photo_size_select_actual,
                                                title: transactionList[index]["trans_name"],
                                                date:   DateFormat.yMd()
                                                    .format(DateTime.parse(transactionList[index]["date"],)),
                                                amount: double.parse(transactionList[index]["amount"]),
                                              ),
                                            ),
                                          );
                                        })

                                ),
                              ],
                            );
                          }
                      }
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('re'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Row _buildTransactionItem(
      {required Color color,
        required IconData iconData,
        required String date,
        required String title,
        required String cat,
        required String des,
        required String project,
        required String user,
        required double amount}) {
    return Row(
      children: <Widget>[
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              user,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              project,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width *.44,
              child: Text(
                maxLines: 3,

                des,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Text(
              "\$ $amount",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
            Text(
              cat,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
List transactionList = [];
  Future getExpense() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("transaction")
        .get();

    // Get data from docs and convert map to List
    transactionList = querySnapshot.docs.where((element) => element["type"] == "expense" &&  monthSelection ==
        int.parse(element["date"]
            .toString()
            .substring(
            5, 7)) &&
        daySelection ==
            int.parse(element["date"]
                .toString()
                .substring(
                8, 10)) && yearSelection ==   int.parse(element["date"]
        .toString()
        .substring(
        0,4)) ).map((doc) => doc.data()).toList();


    print("get all data ${transactionList.length} ");
    return transactionList;
  }
}
