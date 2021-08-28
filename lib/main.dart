import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz4_app/models/user.dart';
import 'package:quiz4_app/screen/wrapper.dart';
import 'package:quiz4_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Userid?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
