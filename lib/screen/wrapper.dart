import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz4_app/models/user.dart';
import 'package:quiz4_app/screen/authenticate.dart';
import 'package:quiz4_app/screen/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Userid?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
