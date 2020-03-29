import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPosition;

  final _toDoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    this._readData().then((data) {
      setState(() {
        this._toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = this._toDoController.text;
      this._toDoController.text = "";
      newTodo["ok"] = false;
      this._toDoList.add(newTodo);

      this._saveData();
    });
  }

  Future<File> _getFile() async {
    final direcory = await getApplicationDocumentsDirectory();
    return File("${direcory.path}/my_tasks.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(this._toDoList);
    final file = await this._getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await this._getFile();

      return file.readAsString();
    } catch (exceptiom) {
      return null;
    }
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      this._toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"]) return 1;
        else if (!a["ok"] && b["ok"]) return -1;
        else return 0;
      });

      this._saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Lista de Tarefas"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: this._toDoController,
                      decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                )),

                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: this._addToDo,
                )
              ],
            ),
          ),

          Expanded(
              child: RefreshIndicator(
                onRefresh: this._refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: this._toDoList.length,
                    itemBuilder: this._buildItem
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),

      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        )
      ),

      direction: DismissDirection.startToEnd,

      child: CheckboxListTile(
        title: Text(this._toDoList[index]["title"]),
        value: this._toDoList[index]["ok"],
        secondary: CircleAvatar(
            child: Icon(this._toDoList[index]["ok"] ? Icons.check : Icons.error)
        ),
        onChanged: (isChecked) {
          setState(() {
            this._toDoList[index]["ok"] = isChecked;
            this._saveData();
          });
        },
      ),

      onDismissed: (direction) {
        setState(() {
          this._lastRemoved = Map.from(this._toDoList[index]);
          this._lastRemovedPosition = index;
          this._toDoList.removeAt(index);

          this._saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${this._lastRemoved["title"]}\" removida!"),

            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  this._toDoList.insert(this._lastRemovedPosition, this._lastRemoved);
                  this._saveData();
                });
              },
            ),

            duration: Duration(seconds: 4)
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }
}
