
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_expense/screen/auth/auth/login_screen.dart';
import 'package:project_expense/screen/auth/auth/admin_login.dart';


class AuthFront extends StatelessWidget {
  const AuthFront({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(


          title:  Text('Authentication',style: TextStyle(
              color: Colors.white,fontSize: 24
          ),),

          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,

        ),
        body:

        Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TabBar(
                          indicatorColor: Colors.orangeAccent,
                          labelColor: Colors.orange,
                          unselectedLabelColor: Colors.blue,
                          unselectedLabelStyle: const TextStyle(
                              fontSize: 12
                          ),
                          labelStyle: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600
                          ),
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              text: 'User Login',
                            ),
                            Tab(
                              text: 'Admin Login',
                            ),

                          ],
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
                 Expanded(
                  child: TabBarView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: LoginScreen(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: AdminLoginScreen(),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
