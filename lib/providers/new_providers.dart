import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class NewProvider extends ChangeNotifier{
  List<Source> musicFiles = [];
  var files;
  var directory;
  String newFilesName="";
  List<String> yeniListe=[];
  List<Source> newMusic=[];
  Future<void> getMusicFiles(String fileName) async {
    final directory = await getExternalStorageDirectory();
    final files = await directory!.list().toList();

    String directoryPath = '/storage/emulated/0/Android/data/com.falcon.text_to_speech/files/';
    String fileName = path.basename(directoryPath);

    Directory directorya = Directory(directoryPath);
    List<String> fileNames = directorya.listSync().map((file) {
      return path.basename(file.path);
    }).toList();

    yeniListe.clear(); // Yeni liste temizleniyor

    for (var eleman in fileNames) {
      yeniListe.add(eleman);
    }

    musicFiles.clear(); // Müzik dosyaları listesi temizleniyor

    for (var file in files) {
      if (file.path.endsWith('.mp3')) {
        musicFiles.add(DeviceFileSource('/storage/emulated/0/Android/data/com.falcon.text_to_speech/files/${fileName}'));
      }
    }

    newMusic.clear(); // Yeni müzik listesi temizleniyor

    for (var file in fileNames) {
      newMusic.add(DeviceFileSource(file));
    }


  }
}