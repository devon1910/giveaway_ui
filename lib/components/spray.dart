import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giveawayui/components/Scan.dart';
import 'package:giveawayui/screens/Transactions.dart';
import 'package:giveawayui/screens/create_event.dart';
import 'package:giveawayui/screens/event_code.dart';
import 'package:giveawayui/screens/receive.dart';
import 'package:http/http.dart' as http;
import 'package:giveawayui/screens/spray_amount.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../size_config.dart';
import 'ActionListTile.dart';
import 'ActionTile.dart';

class Spray extends StatefulWidget {
  const Spray({required this.token});

  final String token;
  @override
  _SprayState createState() => _SprayState();
}

class _SprayState extends State<Spray> {

  bool isTran = false; //checks if Transaction exists
  int amount = 0;
  String transUrl = "https://spray-dev.herokuapp.com/api/transactions/";
  late List<dynamic> data;

  String username = "";
  Future<dynamic> getData() async {
    // Get USER
    final response = await http
        .get(Uri.parse('https://spray-dev.herokuapp.com/api/users/'), headers: {
      'x-auth-token': widget.token,
    });

    final responseJson = jsonDecode(response.body);
    print(responseJson);

    //GET TRANSACTION
    // final responseT = await http.get(
    //     Uri.parse(transUrl),
    //     headers: {
    //       'x-auth-token': widget.token,
    //     });
    var responseT = await http.get(Uri.parse(transUrl), headers: {
      'Accept': 'application/json',
      'x-auth-token': widget.token,
    });

    //final responseTJson = jsonDecode(responseT.body);
    Map<String, dynamic> map = json.decode(responseT.body); //returns a map
    print(map);

    setState(() {
      amount = responseJson['data']['amount'];
      username = responseJson['data']['username'];

      data = map['data'];
      print(data[0]['transaction_date']);
      if (responseT.statusCode == 200) {
        isTran = true;
      }
      print(amount);
      print(username);
    });
  }

  void loadDialog() {
    Alert(
      image: Image.asset('assets/Group.png'),
      useRootNavigator: false,
      context: context,
     // type: AlertType.info,
      //  title: "RFLUTTER ALERT",
      desc: "What do you wanna do?",
      buttons: [
        DialogButton(
          child: Text(
            "Create an event",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            pushNewScreenWithRouteSettings(context,
                settings: RouteSettings(name: CreateEvent.routeName),
                screen: CreateEvent(widget.token),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Spray an Event",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            Alert(
              image: Image.asset('assets/Group.png'),
              useRootNavigator: false,
              context: context,
              // type: AlertType.info,
              //  title: "RFLUTTER ALERT",
              desc: "How do you wanna spray!?",
              buttons: [
                DialogButton(
                  child: Text(
                    "Scan QR code",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                        fontSize: 16),
                  ),
                  onPressed: () {
                    pushNewScreenWithRouteSettings(context,
                        settings: RouteSettings(name: CreateEvent.routeName),
                        screen: Send(token: widget.token),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino);
                  },
                  color: Colors.black,
                ),
                DialogButton(
                  child: Text(
                    "Enter Event code",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14),
                  ),
                  onPressed: () {
                    pushNewScreenWithRouteSettings(context,
                        settings: RouteSettings(name: CreateEvent.routeName),
                        screen: EventCode(token: widget.token),
                        withNavBar: true,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino);
                  },
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                )
              ],
            ).show();
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 240.0),
      color: Color(0xFFFFFFFF),
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(60)),
            gradient: LinearGradient(colors: [
              Color(0xFF3F51B5),
              Color(0xFF38A3A5),
              Color(0xFF38A3A5),
              Color(0xFF38A3A5)
            ]),
            //borderRadius:
          ),
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.only(top: 15.0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/image1.png',
                      height: getProportionateScreenHeight(70)),
                  Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Column(
                        //  margin: EdgeInsets.only(right: 20),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello $username',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w800))),
                          Text('Take a look at your\nwallet. Opor!',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300))),
                        ]),
                  ),
                  Icon(Icons.notifications_none_outlined,
                      size: 40.0, color: Colors.white)
                ],
              ),
            ),
            Container(
                // height: ,
                width: double.infinity,
                margin:
                    EdgeInsets.only(left: getProportionateScreenWidth(40.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$$amount',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 38.0,
                                fontWeight: FontWeight.w900))),
                    Text(
                      'Balance',
                      //textAlign: TextAlign.start,
                      style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400)),
                    )
                  ],
                ))
          ]),
        ),
        //SizedBox(height: getProportionateScreenHeight(5.0),),
        Container(
          //   margin: EdgeInsets.only(bottom: 30.0),
          padding: EdgeInsets.fromLTRB(60, 20, 50, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionTile(
                color: Color(0xffEDF1F9),
                image: Image.asset('assets/deposit.png'),
                text: 'Deposit',
                onClick: () {
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CreateEvent.routeName),
                    screen: CreateEvent(widget.token),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ActionTile(
                color: Color(0xffF4F2F2),
                image: Image.asset('assets/send.png'),
                text: 'Send',
                onClick: () {
                  // pushNewScreenWithRouteSettings(
                  //   context,
                  //   settings: RouteSettings(name: SprayAmount.routeName),
                  //   screen: SprayAmount(),
                  //   withNavBar: true,
                  //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  // );
                },
              ),
              ActionTile(
                color: Color(0xFFD2E1FF),
                image: Image.asset('assets/receive.png'),
                text: 'Receive',
                onClick: () {
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: Receive.routeName),
                    screen: Receive(),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ActionTile(
                color: Color(0xffEDF1F9),
                image: Image.asset('assets/redeem.png'),
                text: 'Redeem',
                onClick: () {
                  //  loadDialog();
                },
              ),
            ],
          ),
        ),
        Container(
          //  color: Colors.red,
          margin: EdgeInsets.fromLTRB(0, 0, 140, 0),
          child: Text(
            'Latest transactions',
            textAlign: TextAlign.start,
            style: GoogleFonts.titilliumWeb(
              textStyle: TextStyle(
                  color: Color(0xFF0D1F3C),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        if (isTran) ...[
          ActionListTile(
              img: 'assets/arrow-up-right-circle.png',
              heading: '${data[0]['transaction_amount']} chi',
              subheading: '${data[0]['type']}',
              message: '${data[0]['payment_method']}',
              date: '${data[0]['transaction_date']}',
              color: 0xFFEDF1F9),
          SizedBox(height: getProportionateScreenHeight(15)),
          GestureDetector(
            onTap: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: Transactions.routeName),
                screen: Transactions(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Text('See all Transactions',
                style: GoogleFonts.nunito(
                    textStyle: TextStyle(
                        color: Color(0xFF3F51B5),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600))),
          ),
        ] else ...[
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Image.asset('assets/Mask.png', height: 50.0, color: Colors.grey),
        SizedBox(height: getProportionateScreenHeight(20)),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 150, 0),
          child: Text('No Transactions',
              style: GoogleFonts.nunito(
                  textStyle: TextStyle(
                      color: Color(0xFF3F51B5),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600))),
        ),
        ],
        GestureDetector(
            onTap: loadDialog,
            child: Container(
                //width: double.infinity,
                margin: EdgeInsets.fromLTRB(
                    0, getProportionateScreenHeight(30.0), 0, 0),
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFFFFFFF)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/Group.png',
                    ),
                  ],
                ))),
        SizedBox(height: getProportionateScreenHeight(10)),
        Text(
          'Spray!',
          style: TextStyle(color: Color(0xFF3F51B5)),
        )
      ]),
    );
  }
}