import 'package:flutter/material.dart';

class loaderComponents extends StatelessWidget {
  final String text;
  loaderComponents({this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
