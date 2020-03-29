import 'package:flutter/material.dart';
import 'package:share/share.dart';


class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._gifData["title"], style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: BackButton(
            color: Colors.white
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            color: Colors.white, onPressed: () {
              Share.share(this._gifData["images"]["fixed_height"]["url"]);
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(this._gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}

