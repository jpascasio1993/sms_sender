import 'package:moor_flutter/moor_flutter.dart';
import './tables.dart';
part 'database.g.dart';

@UseMoor(tables: [OutboxMessages, InboxMessages], daos: [OutboxMessageDao, InboxMessageDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(): super(FlutterQueryExecutor.inDatabaseFolder(path: 'sender.db', logStatements: true));

  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
        // this is just for test, comment on production
        if(from == 1) {
          await migrator.deleteTable(outboxMessages.tableName);
          await migrator.deleteTable(inboxMessages.tableName);
        }
    }
  );
}

@UseDao(tables: [OutboxMessages])
class OutboxMessageDao extends DatabaseAccessor<AppDatabase> with _$OutboxMessageDaoMixin {
  final AppDatabase db;

  OutboxMessageDao(this.db): super(db);

  Future<List<OutboxMessage>> getOutboxMessages({int limit = -1, int offset = 0, bool sent}) {
    final query = (
    select(outboxMessages)
    ..orderBy([
      (outbox) => OrderingTerm(expression: outbox.date, mode: OrderingMode.desc)
    ])
    ..limit(limit, offset: offset)
    );
    if(sent != null) {
      query..where((outbox) => outbox.sent.equals(sent));
    }
    return query.get();
  }

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
    .then((_) => true);
  }

  Future<bool> insertOutbox(List<OutboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        batch.insertAll(outboxMessages, messages);
      });
    }).then((_) => true);
  }
}

@UseDao(tables: [InboxMessages])
class InboxMessageDao extends DatabaseAccessor<AppDatabase> with _$InboxMessageDaoMixin {
  final AppDatabase db;
  InboxMessageDao(this.db): super(db);

  Future<List<InboxMessage>> getInboxMessages({int limit = -1, int offset = 0, bool sent}) {
    final query = (
    select(inboxMessages)
    ..orderBy([
      (inbox) => OrderingTerm(expression: inbox.date, mode: OrderingMode.desc)
    ])
    ..limit(limit, offset: offset)
    );
    if(sent != null) {
      query..where((inbox) => inbox.sent.equals(sent));
    }
    return query.get();
  }

  Stream<List<InboxMessage>> watchInboxMessages({int limit = -1, int offset = 0, bool sent = false}) => (
    select(inboxMessages)
    ..orderBy([
      (inbox) => OrderingTerm(expression: inbox.date, mode: OrderingMode.desc)
    ])
    ..where((inbox) => inbox.sent.equals(sent))
    ..limit(limit, offset: offset)
    )
  .watch();

  Future<bool> updateInbox(List<InboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        messages.forEach((message){
          batch.update(inboxMessages, message,  where: (m) => m.id.equals(message.id));
        });
      });
    })
    .then((_) => true);
  }

  Future<bool> insertInbox(List<InboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        batch.insertAll(inboxMessages, messages);
      });
    }).then((_) => true);
  }
}