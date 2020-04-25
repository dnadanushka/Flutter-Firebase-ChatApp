import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:true_convos/models/messege.dart';
import 'package:true_convos/models/status.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DatabaseService {
  final String uid;
  final String johnID = 'DsmiZ3PfS6fdCcj0KdvyJ2RU0Ig1';

  DatabaseService({this.uid});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //Collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference statusCollection =
      Firestore.instance.collection('status');
  final CollectionReference messegeCollection =
      Firestore.instance.collection('messeges');
  final CollectionReference deviceTokenCollection =
      Firestore.instance.collection('DeviceIDTokens');

  Future updateuserData(String uid, String username, String email) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'username': username,
      'email': email,
    });
  }

  Future updateDeviceToken(String token) async {
    return await deviceTokenCollection.document(_uniqueID(token, uid)).setData({
      'device_id': token,
      'uid': uid,
    });
  }

  Future updateUserStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = prefs.getString(key) ?? '0';
    return await statusCollection.document(status.hashCode.toString()).setData({
      'status': status,
      'uid': uid,
      'username': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  List<Status> _statusListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Status(
          status: doc.data['status'],
          username: doc.data['username'],
          timestamp: doc.data['timestamp'],
          uid: doc.data['uid']);
    }).toList();
  }

  Stream<List<Status>> get statuses {
    return statusCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_statusListFromSnapshot);
  }

  Future sendMessage(String messege, String status, String receiverid) async {
    _updateSingleUser(messege, status, receiverid);
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = prefs.getString(key) ?? '0';

    return await messegeCollection
        .document(_uniqueID(receiverid, uid))
        .collection(status.hashCode.toString())
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      'senderusername': value,
      'senderid': uid,
      'receiverid': receiverid,
      'messege': messege,
      'status': status,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future _updateSingleUser(
      String messege, String status, String receiverid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = prefs.getString(key) ?? '0';

    return await messegeCollection
        .document(receiverid)
        .collection(receiverid)
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData(
      {
        'senderusername': value,
        'senderid': uid,
        'receiverid': receiverid,
        'messege': messege,
        'status': status,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }

  Stream<List<Messege>> messeges(String receiverid, String status) {
    return messegeCollection
        .document(_uniqueID(receiverid, uid))
        .collection(status.hashCode.toString())
        .snapshots()
        .map(_messegeListFromSnapshot);
  }

  Stream<List<Messege>> get recentMesseges {
    return messegeCollection
        .document(uid)
        .collection(uid)
        .snapshots()
        .map(_messegeListFromSnapshot);
  }

  List<Messege> _messegeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Messege(
        senderid: doc.data['senderid'],
        receiverid: doc.data['receiverid'],
        messege: doc.data['messege'],
        status: doc.data['status'],
        timestamp: doc.data['timestamp'],
        senderusername: doc.data['senderusername'],
      );
    }).toList();
  }

  String _uniqueID(String id1, String id2) {
    String groupChatId;
    if (id1.hashCode <= id2.hashCode) {
      groupChatId = '$id1-$id2';
    } else {
      groupChatId = '$id2-$id1';
    }
    return groupChatId;
  }

  Future sendJohnMsg() async {
    johnSingle();

    return await messegeCollection
        .document(_uniqueID(johnID, uid))
        .collection('status'.hashCode.toString())
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData({
      'senderusername': 'John',
      'senderid': johnID,
      'receiverid': uid,
      'messege': 'Hello, How Are You?',
      'status': 'status',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future johnSingle() async {
    return await messegeCollection
        .document(uid)
        .collection(uid)
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData(
      {
        'senderusername': 'John',
        'senderid': johnID,
        'receiverid': uid,
        'messege': 'Hello, How Are You?',
        'status': 'status',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
  }
}
