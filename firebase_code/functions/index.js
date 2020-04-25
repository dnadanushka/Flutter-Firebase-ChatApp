const functions = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

var newData;
var newMessege;

exports.statusTrigger = functions.firestore
  .document("status/{statusid}")
  .onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
      console.log("No Devices");
      return;
    }

    newData = snapshot.data();

    const deviceIdTokens = await admin
      .firestore()
      .collection("DeviceIDTokens")
      .get();

    var tokens = [];

    for (var token of deviceIdTokens.docs) {
      
      tokens.push(token.data().device_id);
    }

    var payload = {
      notification: {
        title: "TrueConvos",
        body: "New Status update",
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        messege: newData.status,
      },
    };

    try {
      const response = await admin.messaging().sendToDevice(tokens, payload);
      console.log("Notification sent successfully");
    } catch (err) {
      console.log(err);
    }
  });

exports.messegeTrigger = functions.firestore
  .document("messeges/{messegesid}/{messegesids}/{messegesiddss}")
  .onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
      console.log("No Devices");
      return;
    }

    newMessege = snapshot.data();

    const deviceIdTokens = await admin
      .firestore()
      .collection("DeviceIDTokens")
      .get();

    var tokens = [];

    for (var token of deviceIdTokens.docs) {
      console.log(token.data().uid === newMessege.receiverid);
      if (token.data().uid === newMessege.receiverid) {
        tokens.push(token.data().device_id);
      }
    }

    var payload = {
      notification: {
        title: "TrueConvos",
        body: 'New messege received',
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        messege: newMessege.messege,
      },
    };

    try {
      const response = await admin.messaging().sendToDevice(tokens, payload);
      console.log("Notification sent successfully");
    } catch (err) {
      console.log(err);
    }
  });
