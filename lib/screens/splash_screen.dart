import 'package:flutter/material.dart';
import 'package:speech_text/screens/pdf_convert.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Belirli bir süre (burada 3 saniye) bekledikten sonra ana sayfaya yönlendirme yapmak için Timer kullanın
    Future.delayed(Duration(seconds: 3), () {
       Navigator.push(context, MaterialPageRoute(builder: (context)=>PDFConverter()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 200,
        ),
      ),
    );
  }
}
