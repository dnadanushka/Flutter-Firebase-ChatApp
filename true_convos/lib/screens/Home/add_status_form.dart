import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:true_convos/models/user.dart';
import 'package:true_convos/services/database.dart';
import '../../globals.dart' as globals;

class AddStatusForm extends StatefulWidget {
  @override
  _AddStatusFormState createState() => _AddStatusFormState();
}

class _AddStatusFormState extends State<AddStatusForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentStatus;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    globals.isReg = false;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Update your status',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: 5,
            inputFormatters: [
              new LengthLimitingTextInputFormatter(140),
            ],
            decoration: InputDecoration(
                hintText:
                    "share stories, fact or information about Coronavirus"),
            validator: (val) => val.isEmpty ? 'Please enter a status' : null,
            onChanged: (val) => setState(() => _currentStatus = val),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Colors.blue,
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await DatabaseService(uid: user.uid)
                      .updateUserStatus(_currentStatus);
                }
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
