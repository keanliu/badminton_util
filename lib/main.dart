import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'orderUtils.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

SharedPreferences? globalSharedPreferences;
// Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalSharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CloudEdge Contacts list',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'CloudEdge information desk'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const INDEX_NEWS = 0;
const INDEX_CONTACTS = 1;
const INDEX_ORDER = 2;
const INDEX_CompanyInfo = 3;

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int currentIndex = 2;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
//        child: _buildContactList(context),
        child: getShowingWidget(currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_new), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: 'Contacts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart), label: 'Order supper'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Company info'),
        ],
        currentIndex: currentIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
          // initialIndex: 1,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getShowingWidget(int index) {
    if (currentIndex == INDEX_NEWS) {
      return _buildNewsList(context);
    } else if (currentIndex == INDEX_CONTACTS) {
      return _buildContactList(context);
    } else if (currentIndex == INDEX_ORDER) {
      return OrderSupperWidget();
    } else {
      return _buildCompanyInfo();
    }
  }

  Widget _buildCompanyInfo() {
    String comapnyName = '趋势科技（中国）有限公司南京分公司';
    String taxNumber = "91320100773960492H";
    String address = "南京市雨花台区安德门大街56号世茂城品国际广场B栋14楼 025-52386000";
    String englishAddress = "14F,Building B, SHI MAO, Link Park, No. 56 An De Men Avenue, Nanjing 210012, P.R.China";
    return Column(
//      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Divider(height: 1.0, indent: 0.0, color: Colors.black),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text("Name:"),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(comapnyName, textAlign: TextAlign.center,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.content_copy),
//                  iconSize: 48,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: comapnyName));
                  },
                ),
              ),
            ),
          ],
        ),
        Divider(height: 1.0, indent: 0.0, color: Colors.black),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text("Tax No.:"),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(taxNumber, textAlign: TextAlign.center,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.content_copy),
//                  iconSize: 48,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: taxNumber));
                  },
                ),
              ),
            ),
          ],
        ),
        Divider(height: 1.0, indent: 0.0, color: Colors.black),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text("Address:"),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(address, textAlign: TextAlign.center,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.content_copy),
//                  iconSize: 48,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: address));
                  },
                ),
              ),
            ),
          ],
        ),
        Divider(height: 1.0, indent: 0.0, color: Colors.black),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text("English address:"),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(englishAddress, textAlign: TextAlign.center,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.content_copy),
//                  iconSize: 48,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: englishAddress));
                  },
                ),
              ),
            ),
          ],
        ),
        Divider(height: 1.0, indent: 0.0, color: Colors.black),
      ],
    );
  }

  Widget _buildOrderPage(BuildContext context) {
    final TextEditingController _controller = new TextEditingController();
    var name = globalSharedPreferences!.getString(USER_NAME_FIELD_NAME)!;

    var result = Column(children: <Widget>[
      Container(
        height: 10,
      ),
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
            new ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      title: new Text('Place order'),
                      content: new Text(_controller.text),
                    );
                  });
              },
              child: new Text('Place order'),
            ),
          ],
        ),
      ),
    ]);
    if (name != null) {
      _controller.text = name;
    }
    return result;
  }

  Widget _buildNewsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("wikiinfo")
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, stream) {

          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }



          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;
          return ListView.builder(
            itemCount: querySnapshot == null ? 0: querySnapshot.size,
            itemBuilder: (context, index) {
              var info = querySnapshot.docs[index];
              return new ExpansionTile(
                title: new Text(
                  info.data()["title"] + " -- " + info.data()["author"],
                  style: new TextStyle(
//                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                children: <Widget>[
                  new Column(crossAxisAlignment: CrossAxisAlignment.start,

//                    children: _buildExpandableContent(info),
                      children: [
                        Row(
                          children: <Widget>[
                            Text("Last update time:  "),
                            Text(
                              info.data()["time"],
                            ),
                          ],
                        ),
                        Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(info.data()["link"])) {
                              await launch(info.data()["link"]);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: info.data()["link"],
                          style: TextStyle(color: Colors.yellow),
                          linkStyle: TextStyle(color: Colors.blue),
                        ),
                      ]),
                ],
              );
            },
          );
        });
  }

  Widget _buildContactList(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("contacts")
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Running here: ${snapshot.error.toString()}");
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
//                      columnSpacing: 200,
                      columns: [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Phone')),
                      ],
                      rows: snapshot.data.docs
                          .map<DataRow>(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element.data()["name"])),
                                    //Extracting from Map element the value
                                    DataCell(Text(element.data()["phone"])),
                                  ],
                                )),
                          )
                          .toList(),
                    ),
                  );
                }
                return Text("should never be here");
              },
            ),
          ),
        ]);
  }
}
