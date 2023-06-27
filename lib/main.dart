
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:speech_text/providers/my_provider.dart';
import 'package:speech_text/screens/pdf_convert.dart';
import 'package:speech_text/services/admob_services.dart';
import 'package:speech_text/services/adrequest.dart';

import 'package:speech_text/services/file_services.dart';


void main() async {
  const SystemUiOverlayStyle(statusBarColor: Colors.white);
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();


  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
        Locale('fr'),
        Locale('de', 'DE'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider (
        providers: [
          ChangeNotifierProvider<MyProvider>(
            create: (context) => MyProvider(), // Provider'ı oluşturun
            child: MyApp(),
          ),  ChangeNotifierProvider<FileService>(
            create: (context) => FileService(), // Provider'ı oluşturun
            child:MyApp(),
          ),  ChangeNotifierProvider<AdmobService>(
            create: (context) => AdmobService(), // Provider'ı oluşturun
            child:MyApp(),
          ),
        ],
        child: MyApp(),
      )
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: tr("text_to_speech"),
      home:    Scaffold(
        body: Consumer<MyProvider>( // Provider'ı tüketin
          builder: (context, provider, child)
    {
      provider.getAdReques();
      return PDFConverter();
    }
      ),
      )
    );
  }
}