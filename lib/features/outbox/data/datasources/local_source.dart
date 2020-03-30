import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class LocalSource {
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox);
  Future<List<OutboxModel>> getOutbox(int limit, int offset, List<int> status, OrderingMode mode);
  Future<bool> bulkUpdateOutbox(List<OutboxMessagesCompanion> messages);
  Future<bool> bulkDeleteOutbox(List<OutboxMessagesCompanion> messages);
  Future<List<OutboxModel>> sendBulkSms(List<OutboxModel> messages);
  Future<int> bulkDeleteOldOutbox(String date);
}

class LocalSourceImpl implements LocalSource {
  final AppDatabase appDatabase;
  final SmsSender smsSender;

  LocalSourceImpl({@required this.appDatabase, @required this.smsSender});

  @override
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox) async {
    final list = remoteSourceOutbox
        .where((outbox) => outbox.recipient != null)
        .map((outbox) => OutboxMessagesCompanion.insert(
            body: Value(outbox.body),
            date: Value(outbox.date),
            title: Value(outbox.title),
            recipient: Value(outbox.recipient),
            status: Value(outbox.status)))
        .toList();
    return await appDatabase.outboxMessageDao.insertOutbox(list).catchError(
        (error) => throw LocalException(message: localErrorMessage));
  }

  @override
  Future<List<OutboxModel>> getOutbox(int limit, int offset, List<int> status, OrderingMode orderingMode) async {
    final res = await appDatabase.outboxMessageDao
        .getOutboxMessages(limit: limit, offset: offset, status: status, orderingMode: orderingMode)
        .catchError(
            (error) => throw LocalException(message: localErrorMessage));
    return res
        .map((outboxMessage) => OutboxModel(
            id: outboxMessage.id,
            title: outboxMessage.title,
            body: outboxMessage.body,
            recipient: outboxMessage.recipient,
            date: outboxMessage.date,
            status: outboxMessage.status,
            priority: outboxMessage.priority))
        .toList();
  }

  @override
  Future<bool> bulkUpdateOutbox(List<OutboxMessagesCompanion> messages) async {
    final res = await appDatabase.outboxMessageDao
        .updateOutbox(messages)
        .catchError((error) =>
            throw LocalException(message: outboxLocalErrorMessageUpdate));
    return res;
  }

  @override
  Future<List<OutboxModel>> sendBulkSms(List<OutboxModel> messages) async {
    if(messages.isEmpty) {
      throw LocalException(message: outboxLocalNoOutboxToBeSentAsSMSError);
    }
    List<Future<OutboxModel>> msgFutures = messages.map((msg) => createSmsFuture(msg, smsSender)).toList();
    return await Future.wait(msgFutures);
  }

  Future<OutboxModel> createSmsFuture(OutboxModel outbox, SmsSender sender) async {
    Completer<OutboxModel> completer = Completer();
    SmsMessage msg = SmsMessage(outbox.recipient, outbox.body);
    msg.onStateChanged.listen((SmsMessageState state) {
        debugPrint('SmsMessageState $state');
        if(state == SmsMessageState.Sent) {
          final resOutbox = OutboxModel(
            priority: outbox.priority,
            body: outbox.body,
            date: outbox.date,
            recipient: outbox.recipient,
            status: OutboxStatus.sent,
            title: outbox.title,
            id: outbox.id
          );  
          completer.complete(resOutbox);
        }
        else if(state == SmsMessageState.Fail) {
          final resOutbox = OutboxModel(
            priority: outbox.priority,
            body: outbox.body,
            date: outbox.date,
            recipient: outbox.recipient,
            status: OutboxStatus.failed,
            title: outbox.title,
            id: outbox.id
          );  
          completer.complete(resOutbox);
        }
    });
    debugPrint('createSmsFuture: $outbox');
    // final provider = await SimCardsProvider().getSimCards();
    // await sender.sendSms(msg, simCard: provider.last);
    
    await sender.sendSms(msg).catchError((error) {
            final resOutbox = OutboxModel(
            priority: outbox.priority,
            body: outbox.body,
            date: outbox.date,
            recipient: outbox.recipient,
            status: OutboxStatus.failed,
            title: outbox.title,
            id: outbox.id
          );  
          completer.complete(resOutbox);
    });
    
    return completer.future;
  }

  @override
  Future<bool> bulkDeleteOutbox(List<OutboxMessagesCompanion> messages) async {
    if(messages.isEmpty) {
      throw LocalException(message: outboxLocalEmptyListDeleteErrorMessage);
    }
    final res = await appDatabase
    .outboxMessageDao
    .batchDeleteOutbox(messages)
    .catchError((error) => throw LocalException(message: outboxLocalErrorMessageDelete));

    return res;
  }

  @override
  Future<int> bulkDeleteOldOutbox(String date) async {
    if(date == null || date.isEmpty) {
      throw LocalException(message: outboxLocalDeleteOldOutboxNoDateMessage);
    }
    final res = await appDatabase
    .outboxMessageDao
    .batchDeleteOldOutbox(date)
    .catchError((error) => throw LocalException(message: outboxLocalDeleteOldOutboxMessage));
    return res;
  }
}
