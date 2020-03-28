import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'list_item.dart';

class ChoreWidget extends StatefulWidget {
  final List<ListItem> listItems;
  final Function refresh;

  ChoreWidget(this.listItems, this.refresh);

  _ChoreWidgetState createState() => _ChoreWidgetState();
}

class _ChoreWidgetState extends State<ChoreWidget> {
  final _inputController = TextEditingController();
  final ScrollController _scrollController = new ScrollController();

  Future<void> _addListElement() async {
    if (_inputController.text == "") return;

    final Database db = await DBProvider.db.getDatabase();
    await db.insert(ListItem.tableName,
        ListItem(text: _inputController.text).toMap(forQuery: true));
    _inputController.text = '';
    await widget.refresh();
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 50);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(180),
      child: Column(
        children: <Widget>[
          Container(
            height: 24,
          ),
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: widget.listItems.length,
              itemBuilder: (BuildContext context, int position) {
                return ListItemWidget(
                    position, widget.listItems[position], widget.refresh);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _inputController,
                    decoration: InputDecoration(hintText: 'Legg til ny'),
                    onSubmitted: (value) {
                      _addListElement();
                    },
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  iconSize: 50,
                  color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    _addListElement();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final int index;
  final ListItem listItem;
  final Function refresh;

  ListItemWidget(this.index, this.listItem, this.refresh);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                (index + 1).toString() + '. ' + listItem.text,
                textScaleFactor: 1.5,
              ),
            ),
            IconButton(
              iconSize: 30,
              color: Colors.red,
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () {
                _delete();
              },
            ),
          ],
        ));
  }

  Future<void> _delete() async {
    final Database db = await DBProvider.db.getDatabase();
    await db.delete(ListItem.tableName, where: 'id = ${listItem.id}');
    refresh();
  }
}
