import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_expense/screen/auth/auth/auth_front.dart';
import 'package:project_expense/screen/home_page.dart';




class SplashPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                AuthFront()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Icon(Icons.monetization_on_sharp, size: 200,color: Colors.green,)
    );
  }
}

