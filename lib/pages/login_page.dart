import 'dart:io';

import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String phoneNumber = '';

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK", style: TextStyle(
        color: Color(0XFF09B521)
      ),),
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

  whatsapp(String phoneNumber) async{
    var contact = phoneNumber;
    var androidUrl = "whatsapp://send?phone=$contact&text=Hello";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try{
      if(Platform.isIOS){
        await launchUrl(Uri.parse(iosUrl));
      }
      else{
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception{
      showAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  SizedBox(height:  MediaQuery.of(context).size.height * 0.1,),
                  Lottie.asset('assets/logo.json',height: MediaQuery.of(context).size.height * 0.2 ),
                  SizedBox(height:  MediaQuery.of(context).size.height * 0.08,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: IntlPhoneField(
                      decoration:  const InputDecoration(
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
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0XFF09B521)),
                        ),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                        if(phone.completeNumber.length == 13){
                          setState(() {
                            phoneNumber = phone.completeNumber;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height * 0.02,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              if(phoneNumber.length != 13){
                                print("this is not phoneNumber");
                              }
                              else{
                                print("this is phoneNumber");
                                whatsapp(phoneNumber);
                              }
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
                              'WHATSAPP NOW',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height * 0.08,),
                  const BulletedList(
                    listItems: [
                      Text(
                        'We do not store any data or information with us.',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        'Its local app in your mobile which is secure and safe.',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        'To run our expenses, we only show ads once a while.',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                    bullet: Icon(Icons.check_circle_outlined),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'WEBSITE |',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                Text(
                  'TERMS |',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                Text(
                  'POLICY',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
