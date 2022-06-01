import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:core';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

const ORDER_ADDRESS = "http://cdcfan.tw.trendnet.org";
const USER_NAME_FIELD_NAME = 'UserName';

class OrderSupperWidget extends StatefulWidget {
  _OrderSupperWidget createState() => _OrderSupperWidget();
}

class _OrderSupperWidget extends State<OrderSupperWidget> {
  String message = "";
  String? name = "";

  void getCurrentOrderStatus() async {
    if (this.name != null) {
      developer.log("this.name is not null: ${this.name}");
      searchUser(name!).then((value) {
        developer.log("search user result: $value");
        var data = jsonDecode(value);
        var psID = data['psid'];
        getOrder(psID.toString()).then((value) {
          developer.log("get order, value: $value");
          var order = jsonDecode(value);
          if (order.length > 0) {
            setState(() {
              this.message = 'Looks like you have already ordered supper';
              setState(() {});
            });
          }
        });
      }, onError: (error) {
        print("");
      });
    }
  }

  void checkAndPlaceOrder(String userName) async {
    developer.log("Enter checkAndPlaceOrder");
    var result = await searchUser(userName);
    developer.log("searchUser Result: $result");
    if (result.trim() == '404 Not Found') {
      this.message =
          'The input user is not known by system, please input appropriate user';
      setState(() {});
      return;
    }
    var data = jsonDecode(result);
    var psID = data['psid'];
    result = await getOrder(psID.toString());
    developer.log("getOrder Result: $result");
    var order = jsonDecode(result);
    if (order.length > 0) {
      globalSharedPreferences!.setString(USER_NAME_FIELD_NAME, userName);
      this.name = userName;
      this.message = "Looks like you have aleady ordered supper!";
      setState(() {});
      return;
    } else {
      result = await placeOrder(data['psid'].toString(), data['depcode']);
      data = jsonDecode(result);
      if (data.containsKey("succeed_count") && data['succeed_count'] > 0) {
        globalSharedPreferences!.setString(USER_NAME_FIELD_NAME, userName);
        this.name = userName;
        this.message = "Successfully ordered dinner, have a nice meal";
        setState(() {});
      } else {
        this.message = "For some unknown reason, your order is failed, original message is: \r\n \r\n$result";
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    var userName = globalSharedPreferences!.getString(USER_NAME_FIELD_NAME);
    this.name = userName;
    developer.log("inside initState()");
    developer.log("this.message: ${this.message}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentOrderStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = new TextEditingController();
    var result = Column(children: <Widget>[
      Container(
        height: 20,
      ),
      Container(
        child: Center(
          child: Text(
              "Liability disclaimer: use at your own full responsibility",
              style: TextStyle(fontSize: 10)),
        ),
      ),
      Container(height: 30),
      Container(
        child: Image.asset("assets/dinner.png"),
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: const EdgeInsets.all(20.0),
              child: new TextField(
                controller: _controller,
                decoration: new InputDecoration(
//                  contentPadding: const EdgeInsets.all(20.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Input your name',
                ),
              ),
            ),
            new RaisedButton(
              onPressed: () {
                var userName = _controller.text;
                userName = userName.trim();
                if ((userName != null) && (userName != '')) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    checkAndPlaceOrder(userName);
                  });
                }
              },
              child: new Text('Place order'),
            ),
          ],
        ),
      ),
      Container(height: 50),
      Center(
        child: Container(
//          alignment: MainAxisAlignment.center,,
          padding: new EdgeInsets.all(20.0),
          child: (this.message != null) ? Text(message, textAlign: TextAlign.center,) : Text(""),
        ),
      ),
    ]);
    if (name != null) {
      _controller.text = name!;
    }
    return result;
  }
}

Future<String> searchUser(String userName) async {
//  GET /api/user-search?identity=happy+li&_=1601180205513 HTTP/1.1
//  {"psid": 14802, "name": "Kean Liu", "manager": "Chen Wang", "cnname": "\u5218\u514b\u79d1", "enname": "Kean Liu", "depcode": "CHT.5632N"}
  var entryPoint = "/api/user-search";
  var userParam = Uri.encodeFull(userName);
  var timeValue = DateTime.now().millisecondsSinceEpoch;
  var getURL = '$ORDER_ADDRESS$entryPoint?identity=$userParam&_=$timeValue';
  developer.log("searchUser, getURL: $getURL");
  var response = await http.get(
    Uri.parse(getURL),
    headers: <String, String>{
      'X-Requested-With': 'XMLHttpRequest',
    },
  );
  developer.log(response.body.toString());
  return response.body;
  //{"psid": 14802, "name": "Kean Liu", "manager": "Chen Wang", "cnname": "\u5218\u514b\u79d1", "enname": "Kean Liu", "depcode": "CHT.5632N"}
}

Future<String> getOrder(String psID) async {
//  GET /api/my-orders?psid=14802&_=1601179802259 HTTP/1.1
  var entryPoint = "/api/my-orders";
//  var userParam = Uri.encodeFull(userName);
  var timeValue = DateTime.now().millisecondsSinceEpoch;
  var getURL = '$ORDER_ADDRESS$entryPoint?psid=$psID&_=$timeValue';
  developer.log("getOrder, getURL: $getURL");
  var response = await http.get(
    Uri.parse(getURL),
    headers: <String, String>{
      'X-Requested-With': 'XMLHttpRequest',
    },
  );
  developer.log(response.toString());
  return response.body;
  //[]
  //[{"orderid": 108938, "status": "p", "foodprice": 25, "delivery": "e", "foodname": "\u76d2\u996d"}]
}

//postData(Map<String, dynamic> body)async{
//  var dio = Dio();
//  try {
//    FormData formData = new FormData.fromMap(body);
//    var response = await dio.post(url, data: formData);
//    return response.data;
//  } catch (e) {
//    print(e);
//  }
//}
Future<String> placeOrder(String psID, String depCode) async {
//  order=e-1&psid=14802&depcode=CHT.5632N

  var url = "$ORDER_ADDRESS/api/order-new";
  var data = {"order": "e-1", "psid": psID, "depcode": "depCode"};
  developer.log("placeOrder, data: $data");
  var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: data);
  developer.log(response.body.toString());
  return response.body;
//    developer.log(response.toString());
}
