import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:invmanager/model/item_model.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDb();
    return _database;
  }


  initDb() async {
    var drv = await openDatabase(
      join(await getDatabasesPath(), 'item_stocks.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          create table items (
            _id integer primary key autoincrement,
            name text not null,
            date text not null,
            code text not null,
            stock integer not null 
          )
          '''
        );
      },
      version: 1
    );
    await drv.execute("DROP TABLE IF EXISTS items");
    await drv.execute(
    '''
    create table items (
      _id integer primary key autoincrement,
      name text not null,
      date text not null,
      code text not null,
      stock integer not null 
    )
    '''
    );
    return drv;
  }

  Future<Item> newItem(Item item) async {
    final db = await database;
    item.id = await db.insert("items", item.toMap());
    return item;
  }

  editStock(Item item) async {
    final db = await database;
    db.update("items", item.toMap(), where: '_id = ?', whereArgs: [item.id]);
  }

  clear() async {
    final db = await database;
    await db.rawDelete("DELETE FROM items");
  }

  Future<dynamic> getItems() async {
    final db = await database;
    List<Item> result = new List<Item>();
    List<Map> maps = await db.query("items");
    if (maps.length == 0) {
      return null;
    } else {
      maps.forEach((element) { 
        result.add(Item.fromMap(element));
      });
      return result;
    }
  }
}