import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:speech_text/services/file_services.dart';
import '../providers/my_provider.dart';

class PDFConverter extends StatefulWidget {
  @override
  _PDFConverterState createState() => _PDFConverterState();
}

class _PDFConverterState extends State<PDFConverter> {
  final TextEditingController _text = TextEditingController();
  final AdmobService admobService = AdmobService();
bool isLoading=false;
  String filePath = "";
  Source? auidoFile;


  NativeAd? knativeAd;

  bool nativeAdIsLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2247696110'
      : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad.
  void loadAd() {
    knativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.medium,
          // Optional: Customize the ad's style.
          mainBackgroundColor: Colors.white,

          cornerRadius: 10.0,
        ))
      ..load();
  }


  bool showFile = true;

  @override
  void initState() {
    super.initState();
    admobService.loadRewardedAd();
    admobService.loadAd();
    loadAd();
  }

  @override
  Widget build(BuildContext context) {
    var point = Provider.of<MyProvider>(context).puan;
    var isYuklendiProv = Provider.of<FileService>(context).isYuklendi;
    var isLoadingProv = Provider.of<FileService>(context).isLoading;
    var adProvknative=Provider.of<AdmobService>(context).knativeAd ;
    var adProvload=Provider.of<AdmobService>(context).loadAd();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("text_to_speech"),
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              admobService.showRewardedAd(context);
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/coin.png"),
                      )),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 15,
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(" $point",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(blurRadius: 1)],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 3,
                          maxLength: 5000,
                          decoration: InputDecoration(
                            hintText: tr('enter_text'),
                            border: InputBorder.none,
                          ),
                          controller: _text,
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          TextButton(
                            child: Text(tr('save')),
                            onPressed: () async {
                              print("isProv : $isYuklendiProv");
                              if (point == 0) {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text('Bakiye Sıfır'),
                                      content: Text(
                                          'Cüzdan Sıfır.Devam Edebilmek için Bakiye Yükleyin.\n (Bakiyenizi Reklam İzleyerek Arttırabilirsiniz) '),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Tamam"),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              admobService
                                                  .showRewardedAd(context);
                                            },
                                            child: Text("Bakiye Arttır")),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                if (_text.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Container(
                                      child: Text(tr("enter_text_error")),
                                    ),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  Provider.of<FileService>(context, listen: false).speak(context, _text);

                                  isLoadingProv=true;

                                }
                              }
                            },
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextButton(
                              child: Text(
                                tr('play'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                if (point == 0) {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: Text('Bakiye Sıfır'),
                                        content: Text(
                                            'Cüzdan Sıfır.Devam Edebilmek için Bakiye Yükleyin.\n (Bakiyenizi Reklam İzleyerek Arttırabilirsiniz) '),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Tamam"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  if (_text.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Container(
                                        child: Text(tr("enter_text_error")),
                                      ),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    Provider.of<FileService>(context).onylSpeak(context, _text);

                                    isLoadingProv=true;

                                    Provider.of<MyProvider>(context, listen: false).decrementPuan();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Container(
                alignment: Alignment.center,
                child: AdWidget(
                  ad:adProvknative!,
                ),
                width: double.infinity,
                height: 375,
              ),
              isYuklendiProv == false
                  ? CircularProgressIndicator()
                  : (isLoadingProv == false
                      ? SizedBox()
                      : AudioPlayerScreen(
                          source: filePath,
                        )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        color: Colors.black,
        child: Container(
          child: AdWidget(
            ad: admobService.createBannerAd()..load(),
          ),
        ),
      ),
    );
  }
}
