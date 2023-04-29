import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_expense/const/colors.dart';
import 'package:project_expense/screen/auth/auth/auth_front.dart';
import 'package:project_expense/screen/auth/auth/login_screen.dart';
import 'package:project_expense/screen/home_page.dart';
import 'package:project_expense/utils/helper.dart';
import 'package:project_expense/widget/customTextInput.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final picker = ImagePicker();
  bool loading = false;
  File? imagefile;
  var uuid = Uuid();
  String? downloadUrl;
  final FirebaseStorage storage = FirebaseStorage.instance;
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

  CollectionReference trainCanteen =
      FirebaseFirestore.instance.collection('project_expense');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: Helper.getScreenWidth(context),
        height: Helper.getScreenHeight(context) * 1.3,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              children: [
                Text(
                  "Sign Up",
                  style: Helper.getTheme(context).headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Add your details to sign up",
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: nameController,
                    keybrdType: true,
                    hintText: "Name"),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: emailController,
                    keybrdType: true,
                    hintText: "Email"),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: mobileController,
                    keybrdType: false,
                    hintText: "Mobile No"),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: addressController,
                    keybrdType: true,
                    hintText: "Address"),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: passController,
                    keybrdType: true,
                    hintText: "Password"),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(
                    textController: confirmPassController,
                    keybrdType: true,
                    hintText: "Confirm Password"),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  'Photos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Tap to Upload',
                                  style: TextStyle(color: Colors.white),
                                )
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    try {
                      print("uui id is ${uuid.v1().toString()}");
                      trainCanteen
                          .doc("9dP3oajtd2Q7JWoqAAd7")
                          .collection("registration")
                          .add({
                        "name": nameController.text,
                        "email": emailController.text,
                        "mobile": mobileController.text,
                        "address": addressController.text,
                        "pass": passController.text,
                        "project": "gher",
                        "user_type": "admin",
                        "approved": false,
                        "pass": passController.text,
                        "id": uuid.v1().toString()
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });
                        nameController.clear();
                        emailController.clear();
                        mobileController.clear();
                        addressController.clear();
                        passController.clear();
                        final snackBar = SnackBar(
                          content: const Text('Registration Completed'),

                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushAndRemoveUntil<dynamic>(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => AuthFront(),
                          ),
                          (route) =>
                              false, //if you want to disable back feature set to false
                        );
                      });
                    } catch (e) {
                      print("regitrstion error is ${e.toString()}");
                    }
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.grey.withOpacity(.35))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: loading == true ? Center(
                          child: CircularProgressIndicator(),
                        ):Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => AuthFront(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account?"),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: AppColor.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
