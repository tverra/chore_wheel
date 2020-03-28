import 'dart:convert';

class ListItem {
  static const String tableName = 'list_item';
  static const String colId = 'id';
  static const String colText = 'text';

  int id;
  String text;

  ListItem({this.id, this.text});

  static String getTable() {
    return '$tableName ('
        '$colId INTEGER PRIMARY KEY UNIQUE, $colText TEXT NOT NULL)';
  }

  static List<String> getIndexes() {
    return <String>[];
  }

  List<String> getColumns() {
    return <String>[colId, colText];
  }

  String getTableName() {
    return tableName;
  }

  ListItem.fromMap(Map<String, dynamic> o) {
    if (o[colId] != null) id = int.tryParse(o[colId].toString());
    if (o[colText] != null) text = o[colText] as String;
  }

  Map<String, dynamic> toMap({bool forQuery = false, bool forJson = false}) {
    final map = <String, dynamic>{};
    if (id != null) map[colId] = id;
    if (text != null) map[colText] = text;

    return map;
  }

  String toJson() {
    return json.encode(toMap(forJson: true));
  }

  static List<ListItem> fromJson(String jsonBody) {
    final Iterable list = json.decode(jsonBody) as Iterable;
    var objList = <ListItem>[];
    try {
      objList = list
          .map((cartItem) => ListItem.fromMap(cartItem as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error when parsing from json: ${e.toString()}');
    }
    return objList;
  }

  static List<ListItem> fromMapList(List<dynamic> data) {
    final List<ListItem> objList = <ListItem>[];
    for (final map in data) {
      final obj = ListItem.fromMap(map as Map<String, dynamic>);
      objList.add(obj);
    }
    return objList;
  }

  static List<Map<String, dynamic>> toMapList(List<ListItem> cartItems,
      {bool forQuery, bool forJson}) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for (final ListItem cartItem in cartItems) {
      final map = cartItem.toMap(forQuery: forQuery, forJson: forJson);
      mapList.add(map);
    }
    return mapList;
  }

  @override
  String toString() {
    return toJson();
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is ListItem && id == other.id && text == other.text;

  @override
  int get hashCode => id.hashCode ^ text.hashCode;
}
