import 'package:moor_flutter/moor_flutter.dart';
import './tables.dart';
part 'database.g.dart';

@UseMoor(
    tables: [OutboxMessages, InboxMessages],
    daos: [OutboxMessageDao, InboxMessageDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'sender.db', logStatements: false));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onUpgrade: (migrator, from, to) async {
        // this is just for test, comment on production
        // if (from == 1) {
        //   await migrator.deleteTable(outboxMessages.tableName);
        //   await migrator.deleteTable(inboxMessages.tableName);
        // }

        if(to == 2) {
          await migrator.addColumn(outboxMessages, outboxMessages.priority);
          await migrator.addColumn(inboxMessages, inboxMessages.priority);
        }
      });
}

@UseDao(tables: [OutboxMessages])
class OutboxMessageDao extends DatabaseAccessor<AppDatabase>
    with _$OutboxMessageDaoMixin {
  final AppDatabase db;

  OutboxMessageDao(this.db) : super(db);

  Future<List<OutboxMessage>> getOutboxMessages(
      {int limit = -1, int offset = 0, List<int> status, OrderingMode orderingMode = OrderingMode.desc}) {
    final query = (select(outboxMessages)
      ..orderBy([
        (outbox) => OrderingTerm(expression: outbox.priority, mode: OrderingMode.asc),
        (outbox) => OrderingTerm(expression: outbox.id, mode: orderingMode)
      ])
      ..limit(limit, offset: offset));
    if (status != null) {
      query..where((outbox) => outbox.status.isIn(status));
    }
    return query.get();
  }

  Stream<List<OutboxMessage>> watchOutboxMessages(
          {int limit = -1, int offset = 0, int status = 0, OrderingMode orderingMode = OrderingMode.desc}) =>
      (select(outboxMessages)
            ..orderBy([
              (outbox) =>
                  OrderingTerm(expression: outbox.id, mode: orderingMode)
            ])
            ..where((outbox) => outbox.status.equals(status))
            ..limit(limit, offset: offset))
          .watch();

  Future<bool> updateOutbox(List<OutboxMessagesCompanion> messages) {
    if(messages.isEmpty) return Future.value(false);

    return transaction(() async {
      await batch((batch) {
        messages.forEach((message) {
          batch.update(outboxMessages, message,
              where: (m) => m.id.equals(message.id.value));
        });
      });
    }).then((_) => true);
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
class InboxMessageDao extends DatabaseAccessor<AppDatabase>
    with _$InboxMessageDaoMixin {
  final AppDatabase db;
  InboxMessageDao(this.db) : super(db);

  Future<List<InboxMessage>> getInboxMessages(
      {int limit = -1, int offset = 0, List<int> status, OrderingMode orderingMode = OrderingMode.desc}) {
    final query = (select(inboxMessages)
      ..orderBy([
        (inbox) => OrderingTerm(expression: inbox.priority, mode: OrderingMode.asc),
        (inbox) => OrderingTerm(expression: inbox.id, mode: orderingMode)
      ])
      ..limit(limit, offset: offset));
    if (status != null) {
      query..where((inbox) => inbox.status.isIn(status));
    }
    return query.get();
  }

  Stream<List<InboxMessage>> watchInboxMessages(
          {int limit = -1, int offset = 0, int status = 0, OrderingMode orderingMode = OrderingMode.desc}) =>
      (select(inboxMessages)
            ..orderBy([
              (inbox) =>
                  OrderingTerm(expression: inbox.id, mode: orderingMode)
            ])
            ..where((inbox) => inbox.status.equals(status))
            ..limit(limit, offset: offset))
          .watch();

  Future<bool> updateInbox(List<InboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        messages.forEach((message) {
          batch.update(inboxMessages, message,
              where: (m) => m.id.equals(message.id.value));
        });
      });
    }).then((_) => true);
  }

  Future<bool> insertInbox(List<InboxMessagesCompanion> messages) {
    return transaction(() async {
      await batch((batch) {
        batch.insertAll(inboxMessages, messages);
      });
    }).then((_) => true);
  }
}
