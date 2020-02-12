import 'package:moor_flutter/moor_flutter.dart';
import './tables.dart';
part 'database.g.dart';

@UseMoor(tables: [OutboxMessages], daos: [OutboxMessageDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(): super(FlutterQueryExecutor.inDatabaseFolder(path: 'sender.db', logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [OutboxMessages])
class OutboxMessageDao extends DatabaseAccessor<AppDatabase> with _$OutboxMessageDaoMixin {
  final AppDatabase db;

  OutboxMessageDao(this.db): super(db);

  Future<List<OutboxMessage>> getOutboxMessages({int limit = -1, int offset = 0, bool sent = false}) => (
    select(outboxMessages)
    ..orderBy([
      (outbox) => OrderingTerm(expression: outbox.date, mode: OrderingMode.desc)
    ])
    ..where((outbox) => outbox.sent.equals(sent))
    ..limit(limit, offset: offset)
    )
  .get();

  Stream<List<OutboxMessage>> watchOutboxMessages({int limit = -1, int offset = 0, bool sent = false}) => (
    select(outboxMessages)
    ..orderBy([
      (outbox) => OrderingTerm(expression: outbox.date, mode: OrderingMode.desc)
    ])
    ..where((outbox) => outbox.sent.equals(sent))
    ..limit(limit, offset: offset)
    )
  .watch();

  Future<bool> updateOutbox(List<OutboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        messages.forEach((message){
          batch.update(outboxMessages, message,  where: (m) => m.id.equals(message.id));
        });
      });
    })
    .then((_) => true)
    .catchError((error) => false);
  }

  Future<bool> insertOutbox(List<OutboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        batch.insertAll(outboxMessages, messages);
      });
    }).then((_) => true)
    .catchError((error) => false);
  }
}