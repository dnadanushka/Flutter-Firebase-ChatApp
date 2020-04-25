import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showPlatformDialogue(context,
    {@required String title,
    Widget content,
    String action1Text,
    bool action1OnTap,
    String action2Text,
    bool action2OnTap}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            if (action2Text != null && action2OnTap != null)
              FlatButton(
                child: Text(action2Text),
                onPressed: () {
                  if (action2OnTap == null) {
                    return Navigator.of(context).pop();
                  } else if (action2OnTap) {
                    return Navigator.of(context).pop(true);
                  } else {
                    return Navigator.of(context).pop(false);
                  }
                },
              ),
            FlatButton(
              child: Text(action1Text ?? "OK"),
              onPressed: () {
                if (action1OnTap == null) {
                  return Navigator.of(context).pop();
                } else if (action1OnTap) {
                  return Navigator.of(context).pop(true);
                } else {
                  return Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      } else {
        return CupertinoAlertDialog(
          content: content,
          title: Text(title),
          actions: <Widget>[
            if (action2Text != null && action2OnTap != null)
              CupertinoDialogAction(
                child: Text(action2Text),
                onPressed: () {
                  if (action2OnTap == null) {
                    return Navigator.of(context).pop();
                  } else if (action2OnTap) {
                    return Navigator.of(context).pop(true);
                  } else {
                    return Navigator.of(context).pop(false);
                  }
                },
              ),
            CupertinoDialogAction(
              child: Text(action1Text),
              onPressed: () {
                if (action1OnTap == null) {
                  return Navigator.of(context).pop();
                } else if (action1OnTap) {
                  return Navigator.of(context).pop(true);
                } else {
                  return Navigator.of(context).pop(false);
                }
              },
            ),
          ],
        );
      }
    },
  );
}
