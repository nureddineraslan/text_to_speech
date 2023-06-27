import 'dart:io';

import 'package:audioplayers/audioplayers.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_text/screens/audio_player.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:speech_text/services/admob_services.dart';

import '../providers/my_provider.dart';

class FileService extends ChangeNotifier{

  bool isLoading = true;
  List<String> imagePaths = [];


  late final Directory? directory;

  FlutterTts flutterTts = FlutterTts();
  SharedPreferences? _prefs;
  bool? isYuklendi;
  bool isTap = false;
  bool isFinished = false;

  Future<void> stop() async {
    await flutterTts.stop();
    notifyListeners();
  }

  Future<void> resume() async {
    await flutterTts.pause();
    notifyListeners();
  }

  final AdmobService admobService = AdmobService();

  String filePath = "";
  Source? auidoFile;

  Future<void> onylSpeak(BuildContext context,TextEditingController _text) async {
    print("onyl Speak");

    Locale? currentLocale = context.locale;

    String languageCode = currentLocale.languageCode ?? '';


    final Directory? directory = await getExternalStorageDirectory();
    final text = _text.text;
    final words = text.split(' ');
    String firstWord;
    if (words.isNotEmpty) {
      firstWord = words[0];
    } else {
      firstWord = '';
    }
    filePath = '${firstWord}.mp3';

    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.setLanguage(languageCode);
    print(languageCode);
    await flutterTts.speak(_text.text);

notifyListeners();
  }

  Future<void> stopTTS() async {
    await flutterTts.stop();
  }

  Future<void> speak(BuildContext context,TextEditingController _text, ) async {
    Locale? currentLocale = context.locale;

    String languageCode = currentLocale.languageCode ?? '';
    print("Burası çalıştı");
isYuklendi=false;
  print("Birinci isYuklendi $isYuklendi");

    final text = _text.text;
    final words = text.split(' ');
    String firstWord;
    if (words.isNotEmpty) {
      firstWord = words[0];
    } else {
      firstWord = '';
    }
    print(" İlk kelime$firstWord");
    filePath = '${firstWord}.mp3';
    await flutterTts.setVolume(0);
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setSpeechRate(0.5);

    await flutterTts.synthesizeToFile(_text.text, filePath);

    await flutterTts.setPitch(1);
    final Directory? directory = await getExternalStorageDirectory();
    // await flutterTts.speak(_text.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(child: Text(directory.toString())),
      ),
    );

isYuklendi=true;
    print("İkinci isYuklendi $isYuklendi");
    print('Speech file is saved at: $filePath');

    notifyListeners();
  }




}