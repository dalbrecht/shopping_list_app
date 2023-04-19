import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper{
  final int version = 1;
  Database? db;

  DbHelper._internal();
  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'shoppingDB'));
    db ??= await openDatabase(join(await getDatabasesPath(), 'shoppingDB'),
        onCreate: (database, version) {
          database.execute(
              'CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
          database.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, idList Integer, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
        }, version: version);
    return db!;
  }

  Future<int> insertList(ShoppingList shoppingList) async {
    Database localDb = await openDb();
    int id = await localDb.insert('lists', shoppingList.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    shoppingList.setId(id);
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    print(item.toMap());
    Database localDb = await openDb();
    int id = await localDb.insert('items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print(id);
    item.setId(id);
    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    Database ldb = await openDb();
    final List<Map<String, dynamic>> maps = await ldb.query('lists');
    return List<ShoppingList>.generate(maps.length, (i) {
      return ShoppingList(
        name: maps[i]['name'],
        id: maps[i]['id'],
        priority: maps[i]['priority']);});
  }

  Future<List<ListItem>> getItems(ShoppingList shoppingList) async {
    Database ldb = await openDb();
    final List<Map<String, dynamic>> maps = await ldb.query(
      'items',
      where: 'idList = ?',
      whereArgs: [shoppingList.getId()]
    );
    print(maps);
    return List.generate(maps.length, (i) {
      return ListItem(
        name: maps[i]['name'],
        id: maps[i]['id'],
        note: maps[i]['note'],
        shoppingList: shoppingList,
        quantity: maps[i]['quantity']
      );
    });
  }

  Future<int> deleteList(ShoppingList list) async {
    Database ldb = await openDb();
    int result = await ldb.delete("items", where: "idList = ?", whereArgs: [list.getId()]);
    result = await ldb.delete("lists", where: "id = ?", whereArgs: [list.getId()]);
    return result;
  }

  Future<int> deleteItem(ListItem item) async {
    Database ldb = await openDb();
    int result = await ldb.delete("items", where: "idList = ?", whereArgs: [item.getId()]);
    return result;
  }

  Future testDb() async {
    Database localDb = await openDb();
    await localDb.execute('INSERT INTO lists VALUES (0, \'Fruit\', 2)');
    await localDb.execute('INSERT INTO items VALUES (0, 0, \'Apples\', \'2Kg\', \'Better if they are green\')');
    List lists = await localDb.rawQuery('select * from lists');
    List items = await localDb.rawQuery('select * from items');
    print(lists[0].toString());
    print(items[0].toString());

  }
}