import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:onceoff/pages/login_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum Availability { loading, available, unavailable }

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final String DynamicLink = 'https://whatsappwithoutsavenumber.com/welcome';
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final InAppReview _inAppReview = InAppReview.instance;
  Availability _availability = Availability.loading;

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    _loadBannerAd();
    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();

        setState(() {
          _availability = isAvailable && !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;
        });
      } catch (_) {
        setState(() => _availability = Availability.unavailable);
      }
    });

    super.initState();
  }


  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  Future<void> _requestReview() => _inAppReview.requestReview();

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

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginPage(
                phoneNumber: "",
              )));
    }).onError((error) {
      print('onLink error');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset('assets/background.png'),
                        ),
                        Positioned(
                            top: 30,
                            right: 15,
                            child: Image.asset('assets/flag.png')),
                        Center(
                          child: Lottie.asset('assets/logo.json',
                              height: MediaQuery.of(context).size.height * 0.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'OnceOff W/A',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage(
                                  phoneNumber: "",
                                )));
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
                          ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'CLICK TO PROCEED ',
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
                      'No registration or login, its free  forever',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF6F6F6F)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
              _isBannerAdReady ? SizedBox(height:  MediaQuery.of(context).size.height * 0.06,) : const SizedBox(),
              _isBannerAdReady
                  ? SizedBox(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    )
                  : const SizedBox(),
              _isBannerAdReady ? SizedBox(height:  MediaQuery.of(context).size.height * 0.06,) : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Card(
                          elevation: 1,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          color: const Color(0XFFC2FFED),
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Send Unlimited Messages Using OnceOff W/A App',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Card(
                          elevation: 1,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          color: const Color(0XFFFAFFC2),
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'Send WhatsApp Message Without Saving Number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Card(
                          elevation: 1,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          color: const Color(0XFFFAC2FF),
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    'We Do Not Store or Track Any Information; It’s 100% Safe',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
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
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  'This app may show ads occasionally',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF6F6F6F)),
                ),
              ),
              SizedBox(height:  MediaQuery.of(context).size.height * 0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      _requestReview();
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.star_rate,
                            color: Colors.black38,
                            size: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Rate',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share(
                          'Check out this amazing app where you can send WhatsApp message without saving number. Download Now https://play.google.com/store/apps/details?id=com.bootpsider.onceoffwa.onceoff');
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.share,
                            color: Colors.black38,
                            size: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            ),
                          ),

                        ],
                      ),
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
