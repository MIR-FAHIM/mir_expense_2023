import 'package:flutter/material.dart';

class LangProvider extends ChangeNotifier {

  bool bangLang = false;


  changeLang(lang) {
    bangLang = lang ;

    notifyListeners();
  }


}
