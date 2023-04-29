import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:project_expense/const/static.dart';
import 'package:project_expense/screen/auth/auth/sign_up_screen.dart';
import 'package:project_expense/screen/home_page.dart';
import 'package:project_expense/utils/helper.dart';
import 'package:project_expense/widget/customTextInput.dart';



class AdminLoginScreen extends StatefulWidget {
  static const routeName = "/AdminLoginScreen";

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  CollectionReference trainCanteen = FirebaseFirestore.instance.collection('project_expense');
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final picker = ImagePicker();
  bool loading = false;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Future<bool> doesMobileAlreadyExist(String name) async {
    print("+++ $name");
    final QuerySnapshot result = await trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration")
        .where('mobile', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
  Future<bool> doesUserApproved(String pass) async {
    print("+++ $pass");
    final QuerySnapshot result = await trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration")
        .where('pass', isEqualTo: pass).where('approved', isEqualTo: true)
        .limit(1)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
  Future<bool> doesPassAlreadyExist(String pass) async {
    print("+++ $pass");
    final QuerySnapshot result = await trainCanteen.doc("9dP3oajtd2Q7JWoqAAd7").collection("registration")
        .where('pass', isEqualTo: pass)
        .limit(1)
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }
  imagePicker() async {


    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final file = File(pickedFile!.path);
    final fileName = file.path;

    uploadImage(fileName, file);



  }

  uploadImage(fileName, file) async{
    final Reference storageRef = storage.ref();
    final Reference ref = storageRef.child('images/$fileName');
    final TaskSnapshot task = await ref.putFile(file);



    final String downloadUrl = await task.ref.getDownloadURL();
    print("my dowbload url ++++ $downloadUrl");
  }

  /////////



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Helper.getScreenHeight(context),
        width: Helper.getScreenWidth(context),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 30,
            ),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: Helper.getTheme(context).headline6,
                ),
                SizedBox(height: 20,),
                Text('Add your details to login'),
                SizedBox(height: 20,),
                CustomTextInput(
                  textController: mobileController,
                  hintText: "Your mobile",
                ),
                SizedBox(height: 20,),
                CustomTextInput(
                  textController: passController ,
                  hintText: "password",
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: ()async {
                    setState(() {
                      loading = true;
                    });
                    print("login started");
                    doesMobileAlreadyExist(mobileController.text).then((value) {

                      if(value == true){
                        doesPassAlreadyExist(passController.text).then((pass) {
                          if(pass == true){
                            doesUserApproved(passController.text).then((v) {
                              if(v == true){
                                geLoginData(mobileController.text);

                                setState(() {
                                  loading = false;
                                });

                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(

                                    builder: (BuildContext context) => HomePage(1),
                                  ),
                                      (route) => false,//if you want to disable back feature set to false
                                );
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                final snackBar = SnackBar(
                                  content: const Text('You do not have admin permission'),

                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });


                          }else {
                            setState(() {
                              loading = true;
                            });
                            final snackBar = SnackBar(
                              content: const Text('Please check Password'),

                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        });

                      } else {
                        setState(() {
                          loading = true;
                        });
                        final snackBar = SnackBar(
                          content: const Text('Please check Mobile Number Again'),

                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });


                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width ,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: Colors.grey.withOpacity(.35))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(

                        builder: (BuildContext context) => SignUpScreen(),
                      ),
                          (route) => false,//if you want to disable back feature set to false
                    );

                  },
                  child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  Future geLoginData(String mobile) async {
    print("working get logni *&*&*&*&&*&)&)&)^%+++++++++++++++++++++");
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await trainCanteen
        .doc("9dP3oajtd2Q7JWoqAAd7")
        .collection("registration")
        .get();

    // Get data from docs and convert map to List
    List loginList = [];
    loginList = querySnapshot.docs.where((element) => element["mobile"] == mobile  ).map((doc) => doc.data()).toList();
    StaticData.name = loginList[0]["name"];
    StaticData.role = loginList[0]["user_type"];

    print("yo brooooooo ++++ ${StaticData.name}");



    return StaticData.name;
  }

}
