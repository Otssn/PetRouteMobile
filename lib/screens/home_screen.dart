import 'package:flutter/material.dart';
import 'package:pet_route_mobile/models/token.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:pet_route_mobile/screens/login_screen.dart';

import 'document_types_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;
  HomeScreen({required this.token});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: new Center(
            child: new Text('PetRoute'),
          ),
          backgroundColor: Colors.orange[700],
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _logOut();
                },
                icon: Icon(Icons.exit_to_app)),
          ],
          leading: IconButton(onPressed: () => {}, icon: Icon(Icons.home)),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              _getBody(),
              widget.token.user.userType == 0
                  ? _getAdminMenu()
                  : _getUserMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: FadeInImage(
              placeholder: AssetImage('assets/logo.png'),
              image: NetworkImage(widget.token.user.imageFullPath),
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Bienvenid@ ${widget.token.user.fullName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAdminMenu() {
    return CircularMenu(
        alignment: Alignment.bottomRight,
        toggleButtonColor: Colors.orange[600],
        toggleButtonSize: 30,
        radius: 120,
        toggleButtonMargin: 20,
        items: [
          CircularMenuItem(
              icon: Icons.account_box,
              color: Colors.orange[600],
              iconSize: 20,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentTypeScreen(
                      token: widget.token,
                    ),
                  ),
                );
              }),
          CircularMenuItem(
              icon: Icons.change_circle_outlined,
              color: Colors.orange[600],
              iconSize: 20,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.pets_rounded,
              color: Colors.orange[600],
              iconSize: 20,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.people_alt_rounded,
              color: Colors.orange[600],
              iconSize: 20,
              onTap: () {
                //callback
              }),
          CircularMenuItem(
              icon: Icons.perm_identity,
              color: Colors.orange[600],
              iconSize: 20,
              onTap: () {
                //callback
              }),
        ]);
  }

  Widget _getUserMenu() {
    return Container();
  }

  void _logOut() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
