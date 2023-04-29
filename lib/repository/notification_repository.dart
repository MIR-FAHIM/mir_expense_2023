import 'dart:convert';


import 'package:http/http.dart' as http;


class NotificationRepository {

  // "Done") {
  // stausID = 4;


  // "Incomplete") {
  // stausID = 1;


  // "All") {
  // stausID = 0;


  // "Cancelled") {
  // stausID = 11;


  // "Need More Time") {
  // stausID = 13;

  // "Partially Done") {
  // stausID = 3;


  // "Initiated"
  // stausID = 5;


  // TaskController taskController =  TaskController();
  Future sendNotification() async {
    print("working add task");




    Map<String, dynamic> bodyString =
      {
        "to": "fdqOFCUjQES9Wef49qJAXU:APA91bFsFsPWbcd50yXAcGzbCm3XGDsftfOVm3v_KieL3CnQzqvreRkd36MgeTvNxatIxN-KY1gOKMu24FCz2I9-d83HEtIXb6BxjgbgAQqiUM3LWANkuSzHYIaBKw8jhNDvdVxC0dVg",
        "notification": {
          "title": "01Check this Mobile (title)",
          "body": "01Rich Notification testing (body)",
          "mutable_content": true,
          "sound": "Tri-tone"
        },

        "data": {
          "url": "<url of media image>",
          "dl": "<deeplink action on tap of notification>"
        }

    };

    Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
    final response = await http.post(
      url,
      body: jsonEncode(bodyString),
      headers: {
        "Content-Type": "application/json",
        "Authorization":"key=AAAA0cBQl98:APA91bGQjVyAjmxlWQ3JL8gW6KKLgBJtx1bdUtrs5_UBRU3Y-tQ2oT7X2sC2Jmf2CQ2IwIUlk2WRskkgrXadaWtQeqwjDK9AE6ieb993O0THo5sUMrVgAWn09GVA1RT7SIsg2_A40aMN"
      },
    );

    print("my resposnse repo ${response.body}");
    String data = response.body;

    return data;
  }



}
