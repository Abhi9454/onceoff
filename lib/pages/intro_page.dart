import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onceoff/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);



  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.03,),
                    const Text(
                      'OnceOff W/A',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      'by WhatsappWithoutSaveNumber.com',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.06,),
                    Lottie.asset('assets/logo.json',height: MediaQuery.of(context).size.height * 0.2 ),
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.03,),
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Send WhatsApp Message Without Saving Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0XFF09B521)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10.0)),
                                        side: BorderSide(color: Colors.black)))),
                        child: const Text(
                          'CLICK TO PROCEED',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No registration or login, its free  forever',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.2,),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _launchURL('https://whatsappwithoutsavenumber.com');
                    },
                    child: const Text(
                      'WEBSITE |',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      _launchURL('https://whatsappwithoutsavenumber.com/terms.html');
                    },
                    child: const Text(
                      'TERMS |',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      _launchURL('https://whatsappwithoutsavenumber.com/privacy.html');
                    },
                    child: const Text(
                      'POLICY',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
