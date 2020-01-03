import 'package:google_maps/sqlite_curd_operations/UserData.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelperForLogin {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'login.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE login (id INTEGER PRIMARY KEY, username TEXT, password TEXT )');
    print("Tabler Created");
  }

  Future<UserData> add(UserData student) async {
    var dbClient = await db;
    student.id = await dbClient.insert('login', student.toMap());
    return student;
  }

  Future<List<UserData>> getStudents() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query('login', columns: ['id', 'username', 'password']);
    List<UserData> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(UserData.fromMap(maps[i]));
      }
    }
    return students;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'login',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isExist(String userName) async {
    var dbClient = await db;

    var strQuary = "SELECT * FROM login WHERE username = \"$userName\"";

    List<Map> maps = await dbClient.rawQuery(strQuary);
    print(maps);
    if (maps.length > 0) {
      return true;
    }

    return false;


  }

  Future<int> update(UserData student) async {
    var dbClient = await db;
    return await dbClient.update(
      'login',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
