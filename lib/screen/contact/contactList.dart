import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_expense/const/static.dart';
import 'package:project_expense/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _DonationListState();
}

class _DonationListState extends State<ContactList> {
  CollectionReference trainCanteen =
      FirebaseFirestore.instance.collection('project_expense');
  List projectData = [];
  List<String> selectedItemValue = [];
  String? selectedPopular;
  String? selectedRes;
  String? selectedProject = "No Project";
String doc = "";
  String dropdownValue = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Contact List"),
      ),
      body: Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0 * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: getContactList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: ListView.builder(
                                        itemCount: contactList.length,
                                        itemBuilder:
                                            (BuildContext context, index) {

                                             // DocumentSnapshot doc = contactList[index];
                                          return Card(
                                            child: _buildTransactionItem(
                                              index: index,

                                              user: contactList[index]["name"],
                                              mobile: contactList[index]
                                                  ["mobile"],
                                              doc: contactList[index]
                                              ["mobile"],
                                              approve: contactList[index]
                                                  ["approved"],
                                              color: Colors.deepPurpleAccent,
                                              iconData: Icons
                                                  .photo_size_select_actual,
                                            ),
                                          );
                                        })),
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

  Row _buildTransactionItem(
      {required Color color,
        required int index,
      required IconData iconData,
      required String user,
        required String doc,
      required bool approve,
      required String mobile}) {
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
              user,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () {
                launchPhoneDialer(mobile);
              },
              child: Text(
                mobile,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              "Project(Optional)",
              style: Helper.getTheme(context).bodySmall,
            ),
            FutureBuilder(
              future: getProject(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  print("no data found");
                } else {
                  selectedItemValue.clear();
                  print("++++ ++++ +++++${ snapshot.data.length}");


                    selectedItemValue.add( snapshot.data[0]["project_name"]);
                  selectedItemValue.add( snapshot.data[1]["project_name"]);
                  selectedItemValue.add( snapshot.data[2]["project_name"]);
                  selectedItemValue.add( snapshot.data[3]["project_name"]);




                  // selectedRes = allData[0]['name'];
                  // selectedRes = allData[0]["name"];
                }

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
                        height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.black12, width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Padding(
                            padding:
                            const EdgeInsets.only(left: 8, right: 8),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value:  selectedItemValue[index].toString(),
                              icon: Icon(Icons.arrow_drop_down_outlined),
                              elevation: 16,
                              style:
                              const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.transparent,
                              ),
                              onChanged: (String? value) {
                                selectedItemValue[index] = value!;
                                setState(() {});
                              },
                              items: _dropDownItem()
                            ),
                          ));
                    }
                }
              },
            ),
          ],
        ),
        Spacer(),
        GestureDetector(
            onTap: () {
              _launchWhatsapp(mobile);
            },
            child: Icon(
              Icons.message,
              color: Colors.green.withOpacity(.5),
            )),
        GestureDetector(
          onTap: () {
            //_launchWhatsapp(mobile);

             if(StaticData.role == "admin"){
               approve == true ? updateApproval(mobile, false) : updateApproval(mobile, true);
             } else {
               final snackBar = SnackBar(
                 content: const Text('You are not an admin'),

               );
               ScaffoldMessenger.of(context).showSnackBar(snackBar);
             }




          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * .2,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.withOpacity(.35))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: approve == true
                    ? Text(
                        'Approved',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    : Text(
                        'Not Approved',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }
  Future getProject() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("project")
        .get();

    // Get data from docs and convert map to List
    projectData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("get all data ${projectData.length} ");
    return projectData;
  }
  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["No Project", "Madrasa", "gher", "project1"];
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();
  }
updateApproval(String mobile, bool approved){
  trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration")
      .where('mobile', isEqualTo: mobile)
      .get()
      .then((value) {
    trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration").doc(value.docs[0].id.toString()).update({"approved": approved}).then((value) {
      setState(() {

      });
    });

  });

}
  assignProject(String mobile, String project){
    trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration")
        .where('mobile', isEqualTo: mobile)
        .get()
        .then((value) {
      trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration").doc(value.docs[0].id.toString()).update({"project": project}).then((value) {
        setState(() {

        });
      });

    });

  }
  List contactList = [];
  Future getContactList() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("registration")
        .get();

    // Get data from docs and convert map to List
    contactList = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("get all data ${contactList.length} ");
    return contactList;
  }

  _launchWhatsapp(String num) async {
    var whatsapp = "+88${num}";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello Sir");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunch(_phoneUri.toString()))
        await launch(_phoneUri.toString());
    } catch (error) {
      throw ("Cannot dial");
    }
  }
}
