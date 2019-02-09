import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sms_sender/resources/enum.dart';
import 'package:sms_sender/models/outbox_model.dart';

class DatabaseProvider {
  Database db;

  Future<Null> open() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'sms_sender.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE ${OutboxDb.table} (${OutboxDb.id} INTEGER PRIMARY KEY, ${OutboxDb.title} TEXT, ${OutboxDb.body} TEXT, ${OutboxDb.sendTo} TEXT, ${OutboxDb.date} TEXT, ${OutboxDb.status} INTEGER)');
    });
  }

  Future<Null> deleteDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'sms_sender.db');
    await deleteDatabase(path);
  }

  Future<int> insert(OutboxModel outbox) async {
    return await db.insert(OutboxDb.table, outbox.toMap());
  }

  Future<Null> batchInsert(List<OutboxModel> outbox) async {
    // Batch batch = db.batch();
    // return await batch.commit();
    await db.transaction((trx) async {
      Batch batch = trx.batch();
      for (OutboxModel model in outbox) {
        batch.insert(OutboxDb.table, model.toMap());
      }
      await batch.commit(noResult: true);
    });
  }

  Future<Null> batchUpdate(List<OutboxModel> outbox) async {
    // Batch batch = db.batch();
    // return await batch.commit();
    await db.transaction((trx) async {
      Batch batch = trx.batch();
      for (OutboxModel model in outbox) {
        batch.update(OutboxDb.table, model.toMap(),
            where: '${OutboxDb.id} = ?', whereArgs: [model.id]);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<OutboxModel> getOutbox(int id) async {
    List<Map<String, dynamic>> maps = await db.query(OutboxDb.table,
        columns: [
          OutboxDb.id,
          OutboxDb.title,
          OutboxDb.body,
          OutboxDb.sendTo,
          OutboxDb.date,
          OutboxDb.status
        ],
        where: '${OutboxDb.id} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return OutboxModel(maps.first);
    }
    return null;
  }

  Future<List<OutboxModel>> getAllOutbox(OutboxEnum type) async {
    List<OutboxModel> list = List<OutboxModel>();
    List<Map<String, dynamic>> result;
    if (type != null) {
      result = await db.query(OutboxDb.table,
          where: '${OutboxDb.status} = ?', whereArgs: [type.value]);
    } else {
      result = await db.query(OutboxDb.table);
    }

    for (Map<String, dynamic> outbox in result) {
      list.add(OutboxModel(outbox));
    }
    return list;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(OutboxDb.table, where: '${OutboxDb.id} = ?', whereArgs: [id]);
  }

  Future<int> update(OutboxModel outbox) async {
    return await db.update(OutboxDb.table, outbox.toMap(),
        where: '${OutboxDb.id} = ?', whereArgs: [outbox.id]);
  }

  Future close() async => db.close();
}

class OutboxDb {
  static const String table = 'outbox';
  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String sendTo = 'sendTo';
  static const String date = 'date';
  static const String status = 'status';
}

class OutboxEnum<int> extends Enum<int> {
  const OutboxEnum(int val) : super(val);
  static const OutboxEnum SENT = const OutboxEnum(1);
  static const OutboxEnum UNSENT = const OutboxEnum(2);
}
