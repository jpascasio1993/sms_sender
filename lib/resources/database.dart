import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sms_sender/resources/enum.dart';

class Database {
  Database db;

  Future<Null> open() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'sms_sender.db');

    // db = await openDatabase(path, version: 1,
    //     onCreate: (Database db, int version) async {
    //   await db.execute('''
    //     create table $tableTodo (
    //       $columnId integer primary key autoincrement,
    //       $columnTitle text not null,
    //       $columnDone integer not null)
    //     ''');
    // });
  }
}

class OutboxDb {
  static const String table = 'outbox';
  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String date = 'date';
  static const String status = 'status';
}

class OutboxEnum<int> extends Enum<int> {
  const OutboxEnum(int val) : super(val);
  static const OutboxEnum HIGH = const OutboxEnum(100);
  static const OutboxEnum MIDDLE = const OutboxEnum(50);
  static const OutboxEnum LOW = const OutboxEnum(10);
}
