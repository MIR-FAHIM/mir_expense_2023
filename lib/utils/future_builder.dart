import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  TextEditingController searchController = TextEditingController();
  bool department = true;
  method(){

  }
  bool searchStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee List"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [

            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: method(),
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
                      return Container(

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
