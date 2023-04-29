import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.phoneNumber, Key? key}) : super(key: key);

  final String phoneNumber;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phone = '';
  TextEditingController phoneNumberController = TextEditingController();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  bool adShown = false;

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text(
        "OK",
        style: TextStyle(color: Color(0XFF09B521)),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Whatsapp Error"),
      content: const Text("Whatsapp not installed in the device."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd?.dispose();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-6208393215905500/6976955743',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 5) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      setState(() {
        adShown = true;
      });
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    setState(() {
      adShown = true;
    });
  }

  whatsapp(String phoneNumber) async {
    var contact = phoneNumber;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hello";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      showAlertDialog(context);
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-6208393215905500/3968331210',
      request: request,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
    _loadBannerAd();
    if (widget.phoneNumber.isNotEmpty) {
      setState(() {
        phone = widget.phoneNumber;
        phoneNumberController.text = phone;
      });
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
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/logo.json',
                          height: MediaQuery.of(context).size.height * 0.2),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'OnceOff W/A',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: IntlPhoneField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        filled: true,
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hoverColor: Color(0XFF09B521),
                        fillColor: Color(0XFFD0ECEC),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF09B521)),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phones) {
                        print(phones.completeNumber);
                        if (phones.completeNumber.length == 13) {
                          setState(() {
                            phone = phones.completeNumber;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        if (adShown) {
                          if (phone.length != 13) {
                            print("this is not phone");
                            const snackBar = SnackBar(
                              content: Text('Invalid Phone Number'),
                              backgroundColor: Color(0XFF09B521),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            print("this is phone");
                            whatsapp(phone);
                          }
                        } else {
                          _showInterstitialAd();
                        }
                      },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0XFF09B521)),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10.0)),
                              ))),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'WHATSAPP NOW',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'No registration or login, its free',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF6F6F6F)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  // const BulletedList(
                  //   listItems: [
                  //     Text(
                  //       'We do not store any data or information with us.',
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.normal,
                  //           color: Colors.black),
                  //     ),
                  //     Text(
                  //       'Its local app in your mobile which is secure and safe.',
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.normal,
                  //           color: Colors.black),
                  //     ),
                  //     Text(
                  //       'To run our expenses, we only show ads once a while.',
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.normal,
                  //           color: Colors.black),
                  //     )
                  //   ],
                  //   bullet: Icon(Icons.check_circle_outlined, size: 12,),
                  // ),
                  _isBannerAdReady
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        )
                      : const SizedBox(),
                  _isBannerAdReady
                      ? SizedBox(
                          width: _bannerAd.size.width.toDouble(),
                          height: _bannerAd.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd),
                        )
                      : const SizedBox(),
                  _isBannerAdReady
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Card(
                      elevation: 1,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      color: const Color(0XFFFFC2C2),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: const [
                                  Text(
                                    'Excellent for',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'OnceOff Send Location, Files, Address, Document, Brochure, Pdf, Information, etc',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset('assets/sendMessage.png'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
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
                    onTap: () {
                      _launchURL(
                          'https://whatsappwithoutsavenumber.com/terms.html');
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
                    onTap: () {
                      _launchURL(
                          'https://whatsappwithoutsavenumber.com/privacy.html');
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
