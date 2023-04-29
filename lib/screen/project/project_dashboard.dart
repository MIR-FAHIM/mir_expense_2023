import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_expense/screen/home_page.dart';
import 'package:project_expense/screen/project/project_transactions.dart';
import 'package:project_expense/screen/project/theme/colors/light_colors.dart';
import 'package:project_expense/screen/project/widgets/active_project_card.dart';
import 'package:project_expense/screen/project/widgets/task_column.dart';
import 'package:project_expense/screen/project/widgets/top_container.dart';

class ProjectDashBoard extends StatefulWidget {


  @override
  State<ProjectDashBoard> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<ProjectDashBoard> {

  TextEditingController searchController = TextEditingController();
  bool department = true;

  bool searchStart = false;
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }
  CollectionReference trainCanteen =
  FirebaseFirestore.instance.collection('project_expense');

  List projectList = [];
  List expenseList = [];
  double totalExpense = 0.0;
  List incomeList = [];
  double totalIncome = 0.0;
  Future getExpense() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("transaction")
        .get();

    // Get data from docs and convert map to List
    expenseList = querySnapshot.docs.where((element) => element["type"] == "expense"  ).map((doc) => doc.data()).toList();


    print("get all data ${expenseList.length} ");
    return expenseList;
  }
  Future getProject() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("project")
        .get();

    // Get data from docs and convert map to List
    projectList = querySnapshot.docs.map((doc) => doc.data()).toList();

    QuerySnapshot querySnapshotTrans = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("transaction")
        .get();

    expenseList = querySnapshotTrans.docs.where((element) => element["type"] == "expense" ).map((doc) => doc.data()).toList();
    print("expense data list is ${expenseList.length}");
    totalExpense = expenseList.fold(0, (previousValue, element) => previousValue + double.parse(element["amount"]));
    incomeList = querySnapshotTrans.docs.where((element) => element["type"] == "income" ).map((doc) => doc.data()).toList();
    print("expense data list is ${expenseList.length}");
    totalIncome = incomeList.fold(0, (previousValue, element) => previousValue + double.parse(element["amount"]));
    totalBanlance = totalIncome - totalExpense;
    // Get data from docs and convert map to List

    print("get all data ${projectList.length} ");

    return projectList;
  }
getData(int value){
    int data = value;
    print("+++++++++++++++++$data");
    return data;
}
  getProjectData(String project)async{
    double cal =  22;
    print("hlw bro ++++++++++++++++++++++++ $cal");

    return cal;
  }
double totalBanlance = 0.0;

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Projects"),
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



      body:

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [

            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getProject(),
              builder: (BuildContext context,
                 snapshot) {
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
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Project Wise Status"),

                                    SizedBox(height: 10,),

                                    Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child:   Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          subheading('Project Status'),
                                          SizedBox(height: 5.0),
                                          GridView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5.0,
                                              mainAxisSpacing: 0.0,
                                            ),
                                            itemCount: projectList.length,
                                            itemBuilder: (context, index) {
                                            return  FutureBuilder(
                                              future: getProjectData(projectList[index]["project_name"]),
                                              builder: (context, snapshot) {
                                                return GestureDetector(
                                                  onTap: (){
                                                    Navigator.pushAndRemoveUntil<dynamic>(
                                                      context,
                                                      MaterialPageRoute<dynamic>(

                                                        builder: (BuildContext context) => ProjectTransaction(project:projectList[index]["project_name"]),
                                                      ),
                                                          (route) => false,//if you want to disable back feature set to false
                                                    );
                                                  },
                                                  child: incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).isEmpty  || expenseList.where((element) => element["project"] == projectList[index]["project_name"] ).isEmpty?Container(): ActiveProjectsCard(
                                                    radiusss: 40,
                                                    radColor: incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"]))  < expenseList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])) ? Colors.red.withOpacity(.4) : Colors.white,
                                                    cardColor: Colors.green,
                                                    loadingPercent: incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])) < expenseList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])) ? 0 :
                                                    (((incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"]))
                                                    - expenseList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"]))) * 100)
                                                    /incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"]))) /100,
                                                    title: projectList[index]["project_name"],
                                                    income: incomeList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])).toString(),
                                                    expense: expenseList.where((element) => element["project"] == projectList[index]["project_name"] ).fold(0, (previousValue, element) => previousValue + int.parse(element["amount"])).toString(),

                                                  ),
                                                );
                                              }
                                            );

                                            },
                                          ),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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





// ActiveProjectsCard(
// radiusss: 40,
// cardColor: LightColors.kGreen,
// loadingPercent: getProjectData(projectList[0]["project_name"]).then((value) => value / 100,
// title: projectList[index]["project_name"],
// subtitle: totalBanlance.toString(),
// )
// );
