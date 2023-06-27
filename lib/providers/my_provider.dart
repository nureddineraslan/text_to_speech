import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_text/services/admob_services.dart';

class MyProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
bool? isYuklendi;
  int _puan = 20;

  int get puan => _puan;

  MyProvider() {
    _loadPuan();
  }
 void getAdReques(){
    AdmobService().createBannerAd();



 }
  void _loadPuan() async {
    _prefs = await SharedPreferences.getInstance();
    _puan = _prefs.getInt('puan') ?? 20;
    notifyListeners();
  }

  void incrementPuan() {
    _puan += 20;
    _savePuan();
    print("puan İncrement çalıştı: $_puan");
    notifyListeners();
  }
  void decrementPuan(){
    _puan -= 10;
    _savePuan();
    print("puan İncrement çalıştı: $_puan");
    notifyListeners();
  }

  void _savePuan() {
    _prefs.setInt('puan', _puan);
  }
}
