import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:true_convos/services/database.dart';

import 'add_status_form.dart';
import 'messege_list.dart';
import 'status_list.dart';
import '../../services/auth.dart';
import '../../globals.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService(); //fro the sign out

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title = 'Coronavirus (COVID-19) community';
  int _currentIndex = 0;
  String thisDeviceToken = '';

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) async {
      thisDeviceToken = deviceToken;
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message alla hukai");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _configureFirebaseListeners();
  }

  final tabs = [StatusList(), MessegeList()];

  void _showAddStatusForm() {
    globals.isReg =false;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: AddStatusForm(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    Future(() {
      if(globals.isReg){
      setState(() {
        _showAddStatusForm() ;
      });
      globals.isReg = false;
      }


    });


    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
              color: Colors.white),
        ],
      ),
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showAddStatusForm();
          },
          label: Text('Add Status')),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            title: Text('Status'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Messages'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
