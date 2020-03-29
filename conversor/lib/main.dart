import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=21b428c1";

void main() async {
  runApp(MaterialApp(
    home: Home(),

    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    this._verifyIfEmpty(text);
    double real = double.parse(text);
    this.dolarController.text = (real/this.dolar).toStringAsFixed(2);
    this.euroController.text = (real/this.euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    this._verifyIfEmpty(text);
    double dolar = double.parse(text);
    this.realController.text = (dolar * this.dolar).toStringAsFixed(2);
    this.euroController.text = (dolar * this.dolar / this.euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    this._verifyIfEmpty(text);
    double euro = double.parse(text);
    this.realController.text = (euro * this.euro).toStringAsFixed(2);
    this.dolarController.text = (euro * this.euro / this.dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _verifyIfEmpty(String text) {
    if(text.isEmpty) {
      this._clearAll();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true
      ),

      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: Text("Carregando dados...",
                style: TextStyle(color:  Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center));
            default:
              if (snapshot.hasError) {
                return Center(child: Text("Erro ao carregar dados",
                    style: TextStyle(color:  Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center));
              } else {
                this.dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                this.euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),

                      buildTextField("Reais", "R\$", this.realController, this._realChanged),
                      Divider(),

                      buildTextField("Dólares", "US\$", this.dolarController, this._dolarChanged),
                      Divider(),

                      buildTextField("Euros", "€", this.euroController, this._euroChanged)
                    ]
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController textEditingController, Function changeAction) {
  return TextField(
    controller:  textEditingController,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25.0
    ),
    onChanged: changeAction,
    keyboardType: TextInputType.numberWithOptions(decimal: true)
  );
}
