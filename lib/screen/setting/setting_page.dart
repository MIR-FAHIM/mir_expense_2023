
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_expense/const/static.dart';
import 'package:project_expense/screen/splash_screen.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:get/get.dart';
import 'package:project_expense/provider/provider_manager.dart';

import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? fcmtoken = "";
  double screenHeight = 0;
  String versionID = "";
  String buildNumber = "";

  @override
  void initState(){
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    print("my screen size is $size");


    return Consumer<LangProvider>(
        builder: (context, provider, lang) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: provider.bangLang == false ?  Text(
                "Settings",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ) :  Text(
                "সেটিং",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),

              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  // user card
                  SimpleUserCard(
                    userName: StaticData.name,
                    userProfilePic: NetworkImage("https://cdn.pixabay.com/photo/2018/08/28/13/29/avatar-3637561_960_720.png"),
                  ),
                  SettingsGroup(
                    items: [
                      SettingsItem(
                        onTap: () {},
                        icons: Icons.dark_mode_rounded,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          backgroundColor: Colors.red,
                        ),
                        title: provider.bangLang == false ? 'Bangla' : "বাংলা",
                        subtitle: "Automatic",
                        trailing: Switch.adaptive(
                          value: provider.bangLang,
                          onChanged: (value) {
                            Provider.of<LangProvider>(context, listen: false).changeLang(
                                value);
                          },
                        ),
                      ),
                      SettingsItem(
                        onTap: () {
                          _launchInWebViewWithoutJavaScript(Uri.parse("https://docs.google.com/document/d/1E2QNSS-YV4LN1JfcRHhe4GaYQGrkhcDIa2DD6b5jdJQ/edit?usp=sharing" ));
                        },
                        icons: Icons.fingerprint,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          backgroundColor: Colors.red,
                        ),
                        title: provider.bangLang == true ? "প্রাইভেসি এবং পলিসি" :'Privacy and Policy',
                        subtitle: provider.bangLang == true ? "আমাদের প্রাইভেসি এবং পলিসি পড়ুন ":"Please check our privacy policy page",
                      ),
                      SettingsItem(
                        onTap: () {},
                        icons: Icons.dark_mode_rounded,
                        iconStyle: IconStyle(
                          iconsColor: Colors.white,
                          withBackground: true,
                          backgroundColor: Colors.red,
                        ),
                        title: provider.bangLang == true ? "ডার্ক মোড": 'Dark mode',
                        subtitle: "Automatic",
                        trailing: Switch.adaptive(
                          value: false,
                          onChanged: (value) {

                          },
                        ),
                      ),
                    ],
                  ),

                  // You can add a settings title
                  SettingsGroup(
                    settingsGroupTitle: "Account",
                    items: [
                      SettingsItem(
                        onTap: () async {
                          // SharedPreff.to.prefss.remove("token");
                          // SharedPreff.to.prefss.remove("loggedIN");
                          // SharedPreff.to.prefss.remove("employeeID");
                          // SharedPreff.to.prefss.remove("userNAME");
                          // SharedPreff.to.prefss.remove("proLink");
                          // await FirebaseAuth.instance.signOut();

                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(

                              builder: (BuildContext context) => SplashPage(),
                            ),
                                (route) => false,//if you want to disable back feature set to false
                          );
                          //SharedPreff.to.prefss.remove("key");
                        },
                        icons: Icons.exit_to_app_rounded,
                        title: provider.bangLang == true ? "সাইন আউট":  "Sign Out",
                      ),


                      SettingsItem(
                        onTap: () {


                        },
                        icons: CupertinoIcons.asterisk_circle,
                        title: "Version: $versionID + $buildNumber",
                        titleStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  launchURL() async {



    final String googleMapslocationUrl = "https://docs.google.com/document/d/1E2QNSS-YV4LN1JfcRHhe4GaYQGrkhcDIa2DD6b5jdJQ/edit?usp=sharing";



    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }
  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
