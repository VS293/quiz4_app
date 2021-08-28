import 'package:flutter/material.dart';
import 'package:quiz4_app/services/auth.dart';

final AuthService _auth = AuthService();

class AppbarLogout extends StatelessWidget {
  final String name;
  const AppbarLogout(
    this.name, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(name),
      centerTitle: true,
      elevation: 0.0,
      actions: <Widget>[
        ElevatedButton.icon(
          icon: Icon(Icons.person),
          label: Text("logout"),
          onPressed: () async {
            await _auth.signOut();
          },
        )
      ],
    );
  }
}

class AppbarBack extends StatelessWidget {
  final String name;
  const AppbarBack(
    this.name, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        color: Colors.black,
      ),
      title: Text(name),
      centerTitle: true,
      elevation: 0.0,
      actions: <Widget>[],
    );
  }
}
