import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_expense/const/static.dart';
import 'package:project_expense/provider/provider_manager.dart';
import 'package:project_expense/screen/home_page.dart';
import 'package:project_expense/utils/helper.dart';
import 'dart:math';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:project_expense/widget/customTextInput.dart';
import 'package:provider/provider.dart';

class AddIncome extends StatefulWidget {
  static const routeName = '/signUpScreen';

  @override
  State<AddIncome> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<AddIncome> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController desController = TextEditingController();
  var dueTimeController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  Random random = new Random();
  bool loading = false;
  List<String> popular = ["yes", "not"];

  String? downloadUrl;
  CollectionReference trainCanteen =
      FirebaseFirestore.instance.collection('project_expense');
  final picker = ImagePicker();
  File? imagefile;

  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<bool> doesMobileAlreadyExist(String name) async {
    print("+++ $name");
    final QuerySnapshot result = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("registration")
        .where('mobile', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  List projectData = [];

  imagePicker() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    imagefile = file;
    final fileName = file.path;

    uploadImage(fileName, file);
    print("my dowbload url ++++ $downloadUrl");
    return imagefile;
  }

  uploadImage(fileName, file) async {
    final Reference storageRef = storage.ref();
    final Reference ref = storageRef.child('images/$fileName');
    final TaskSnapshot task = await ref.putFile(file);

    downloadUrl = await task.ref.getDownloadURL();
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

  List allData = [];
  List allOffer = [];
  String? selectedPopular;
  String? selectedRes;
  String? selectedProject = "No Project";
  String? selectedOffer;
  Future getData() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("cat_income")
        .get();

    // Get data from docs and convert map to List
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("get all data ${allData.length} ");
    return allData;
  }

  Future getOffer() async {
    print("working");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("offer")
        .get();

    // Get data from docs and convert map to List
    allOffer = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("get all data ${allOffer.length} ");
    return allOffer;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LangProvider>(builder: (context, provider, widget) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: Helper.getScreenWidth(context),
          height: Helper.getScreenHeight(context),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.bangLang == true
                      ? Text(
                          "আয়ের নাম যুক্ত করুন ",
                        )
                      : Text(
                          "Add Income Name",
                        ),
                  CustomTextInput(
                    textController: nameController,
                    hintText: "Add Income Title",
                    keybrdType: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  provider.bangLang == true
                      ? Text(
                          "Amount",
                        )
                      : Text(
                          "Amount",
                          style: Helper.getTheme(context).bodySmall,
                        ),
                  CustomTextInput(
                    textController: priceController,
                    hintText: "Amount",
                    keybrdType: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  provider.bangLang == true
                      ? Text(
                          "বিস্তারিত",
                        )
                      : Text(
                          "Description",
                          style: Helper.getTheme(context).bodySmall,
                        ),
                  CustomTextInput(
                    textController: desController,
                    hintText: "Description",
                    keybrdType: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  provider.bangLang == true
                      ? Text(
                          "ক্যাটাগরি",
                        )
                      : Text(
                          "Category",
                          style: Helper.getTheme(context).bodySmall,
                        ),
                  FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        print("no data found");
                      } else {
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
                                    value: selectedRes,
                                    icon: Icon(Icons.arrow_drop_down_outlined),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedRes = value;
                                      });
                                    },
                                    items: allData.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value["cat_name"].toString(),
                                        child:
                                            Text(value["cat_name"].toString()),
                                      );
                                    }).toList(),
                                  ),
                                ));
                          }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  provider.bangLang == true
                      ? Text(
                          "প্রজেক্ট(অপশনাল)",
                        )
                      : Text(
                          "Project(Optional)",
                          style: Helper.getTheme(context).bodySmall,
                        ),
                  FutureBuilder(
                    future: getProject(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        print("no data found");
                      } else {
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
                                    value: selectedProject,
                                    icon: Icon(Icons.arrow_drop_down_outlined),
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedProject = value;
                                      });
                                    },
                                    items: projectData.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value["project_name"].toString(),
                                        child: Text(
                                            value["project_name"].toString()),
                                      );
                                    }).toList(),
                                  ),
                                ));
                          }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.green, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0))),
                    child: TextFormField(
                      controller: dueDateController,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          String myDate =
                              DateTime(date.year, date.month, date.day)
                                  .toString();
                          String myTime = DateTime(
                            date.hour,
                            date.minute,
                          ).toString();
                          print("my min and sec for due is $myTime");

                          dueDateController.text = myDate.substring(0, 10);
                          dueTimeController.text =
                              date.toString().substring(11, 16);
                          print('confirm $date');
                        }, currentTime: DateTime.now());
                      },
                      onChanged: (value) {
                        // _productController.searchProduct(value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefix: Container(
                          width: 20,
                        ),
                        hintText: 'Due Date',
                        suffixIcon: Icon(
                          Icons.date_range_rounded,
                          color: Color(0xFF7C8DB5),
                          size: 14,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: Colors.green),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  provider.bangLang == true
                      ? Text(
                          "ছবি যুক্ত করুন (অপশনাল)",
                        )
                      : const Text(
                          'Photos(Optional)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            imagePicker().then((e) {
                              if (e != null) {
                                setState(() {});
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(.35))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text('Tap to Upload')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: imagefile == null
                            ? Container()
                            : Image.file(
                                imagefile!,
                                height: 45.0,
                                width: 45.0,
                              ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });

                        if (selectedRes == null ||
                            nameController == null ||
                            priceController == null) {
                          final snackBar = SnackBar(
                            content: const Text('Please Fill all the field'),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          trainCanteen
                              .doc("9dP3oajtd2Q7JWoqAAd7")
                              .collection("transaction")
                              .add({
                            "trans_name": nameController.text,
                            "des": desController.text,
                            "id": random.nextInt(1000),
                            "amount": priceController.text,
                            "type": "income",

                            "category": selectedRes,
                            "project": selectedProject,
                            "date": dueDateController.text.isEmpty  ? DateTime.now().toString() :dueDateController.text,
                            "user": StaticData.name,

                            //"image": downloadUrl!,
                          }).then((value) {
                            if (value.id.isNotEmpty) {
                              setState(() {
                                loading = false;

                                nameController.clear();
                                priceController.clear();

                                selectedPopular = "";

                                downloadUrl = "";
                              });
                              final snackBar = SnackBar(
                                content:
                                    const Text('Expense added successfully'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      HomePage(2),
                                ),
                                (route) =>
                                    true, //if you want to disable back feature set to false
                              );
                            } else {
                              print("error _____");
                            }
                          });
                        }
                      },
                      child: loading == true
                          ? CircularProgressIndicator()
                          : provider.bangLang == true
                              ? Text(
                                  "ইনকাম যুক্ত করুন",
                                )
                              : Text("Add Income"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    });
  }
}
