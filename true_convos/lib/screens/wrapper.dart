import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Home/home.dart';
import 'authenticate.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return Authenticate();
    }else{
      return Home();
    }
  }
}