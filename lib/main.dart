import 'package:chore_wheel/database.dart';
import 'package:chore_wheel/list_item.dart';
import 'package:chore_wheel/wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:winwheel/winwheel.dart';

import 'chore_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.greenAccent,
        backgroundColor: Colors.green.withAlpha(180),
      ),
      title: 'Winwheel Demo App',
      initialRoute: '/',
      routes: {
        '/': (context) => ChoreWheel(),
      },
    );
  }
}

class ChoreWheel extends StatefulWidget {
  _ChoreWheelState createState() => _ChoreWheelState();
}

class _ChoreWheelState extends State<ChoreWheel> {
  final List _colors = [
    Colors.pink,
    Colors.purple,
    Colors.amber,
    Colors.red,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lightBlue
  ];
  List<ListItem> _listItems;
  List<Segment> _segments;

  @override
  void initState() {
    super.initState();
    _loadListItems();
  }

  Future<void> _loadListItems({Function callback}) async {
    final Database db = await DBProvider.db.getDatabase();
    final List<Map<String, dynamic>> res = await db.query(ListItem.tableName);
    _listItems = ListItem.fromMapList(res);

    _initListItems(callback: callback);
  }

  Future<void> _initListItems({Function callback}) async {
    _segments = <Segment>[];

    for (int i = 0; i < _listItems.length; i++) {
      _segments.add(Segment(
          fillStyle: _colors[i % (_colors.length)],
          textFillStyle: Colors.black,
          text: (i + 1).toString(),
          strokeStyle: Colors.yellow));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_segments == null) {
      return Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return TabBarView(
            children: <Widget>[
              _segments.length > 0
                  ? ChoreWheelWidget(_segments, _listItems)
                  : Container(
                      color: Theme.of(context).primaryColor.withAlpha(180),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Svaip til høyre for å starte å legge til '
                              'elementer i listen',
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_forward,
                                size: 40,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 40,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
              ChoreWidget(_listItems, _loadListItems),
            ],
          );
        }),
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final ListItem listItem;

  ListItemWidget(this.listItem);

  @override
  Widget build(BuildContext context) {
    return Text(listItem.text);
  }
}
