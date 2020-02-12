// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class OutboxMessage extends DataClass implements Insertable<OutboxMessage> {
  final int id;
  final String title;
  final String body;
  final String recipient;
  final String date;
  final bool sent;
  OutboxMessage(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.recipient,
      @required this.date,
      @required this.sent});
  factory OutboxMessage.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return OutboxMessage(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      recipient: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}recipient']),
      date: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_time']),
      sent: boolType.mapFromDatabaseResponse(data['${effectivePrefix}sent']),
    );
  }
  factory OutboxMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return OutboxMessage(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      recipient: serializer.fromJson<String>(json['recipient']),
      date: serializer.fromJson<String>(json['date']),
      sent: serializer.fromJson<bool>(json['sent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'recipient': serializer.toJson<String>(recipient),
      'date': serializer.toJson<String>(date),
      'sent': serializer.toJson<bool>(sent),
    };
  }

  @override
  OutboxMessagesCompanion createCompanion(bool nullToAbsent) {
    return OutboxMessagesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      recipient: recipient == null && nullToAbsent
          ? const Value.absent()
          : Value(recipient),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      sent: sent == null && nullToAbsent ? const Value.absent() : Value(sent),
    );
  }

  OutboxMessage copyWith(
          {int id,
          String title,
          String body,
          String recipient,
          String date,
          bool sent}) =>
      OutboxMessage(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        recipient: recipient ?? this.recipient,
        date: date ?? this.date,
        sent: sent ?? this.sent,
      );
  @override
  String toString() {
    return (StringBuffer('OutboxMessage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('recipient: $recipient, ')
          ..write('date: $date, ')
          ..write('sent: $sent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              body.hashCode,
              $mrjc(
                  recipient.hashCode, $mrjc(date.hashCode, sent.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OutboxMessage &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.recipient == this.recipient &&
          other.date == this.date &&
          other.sent == this.sent);
}

class OutboxMessagesCompanion extends UpdateCompanion<OutboxMessage> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> recipient;
  final Value<String> date;
  final Value<bool> sent;
  const OutboxMessagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.recipient = const Value.absent(),
    this.date = const Value.absent(),
    this.sent = const Value.absent(),
  });
  OutboxMessagesCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    @required String body,
    @required String recipient,
    @required String date,
    this.sent = const Value.absent(),
  })  : title = Value(title),
        body = Value(body),
        recipient = Value(recipient),
        date = Value(date);
  OutboxMessagesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String> recipient,
      Value<String> date,
      Value<bool> sent}) {
    return OutboxMessagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      recipient: recipient ?? this.recipient,
      date: date ?? this.date,
      sent: sent ?? this.sent,
    );
  }
}

class $OutboxMessagesTable extends OutboxMessages
    with TableInfo<$OutboxMessagesTable, OutboxMessage> {
  final GeneratedDatabase _db;
  final String _alias;
  $OutboxMessagesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bodyMeta = const VerificationMeta('body');
  GeneratedTextColumn _body;
  @override
  GeneratedTextColumn get body => _body ??= _constructBody();
  GeneratedTextColumn _constructBody() {
    return GeneratedTextColumn(
      'body',
      $tableName,
      false,
    );
  }

  final VerificationMeta _recipientMeta = const VerificationMeta('recipient');
  GeneratedTextColumn _recipient;
  @override
  GeneratedTextColumn get recipient => _recipient ??= _constructRecipient();
  GeneratedTextColumn _constructRecipient() {
    return GeneratedTextColumn(
      'recipient',
      $tableName,
      false,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;
  @override
  GeneratedTextColumn get date => _date ??= _constructDate();
  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'date_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sentMeta = const VerificationMeta('sent');
  GeneratedBoolColumn _sent;
  @override
  GeneratedBoolColumn get sent => _sent ??= _constructSent();
  GeneratedBoolColumn _constructSent() {
    return GeneratedBoolColumn('sent', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, recipient, date, sent];
  @override
  $OutboxMessagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'outbox_messages';
  @override
  final String actualTableName = 'outbox_messages';
  @override
  VerificationContext validateIntegrity(OutboxMessagesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (d.body.present) {
      context.handle(
          _bodyMeta, body.isAcceptableValue(d.body.value, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (d.recipient.present) {
      context.handle(_recipientMeta,
          recipient.isAcceptableValue(d.recipient.value, _recipientMeta));
    } else if (isInserting) {
      context.missing(_recipientMeta);
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (d.sent.present) {
      context.handle(
          _sentMeta, sent.isAcceptableValue(d.sent.value, _sentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxMessage map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return OutboxMessage.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(OutboxMessagesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.body.present) {
      map['body'] = Variable<String, StringType>(d.body.value);
    }
    if (d.recipient.present) {
      map['recipient'] = Variable<String, StringType>(d.recipient.value);
    }
    if (d.date.present) {
      map['date_time'] = Variable<String, StringType>(d.date.value);
    }
    if (d.sent.present) {
      map['sent'] = Variable<bool, BoolType>(d.sent.value);
    }
    return map;
  }

  @override
  $OutboxMessagesTable createAlias(String alias) {
    return $OutboxMessagesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $OutboxMessagesTable _outboxMessages;
  $OutboxMessagesTable get outboxMessages =>
      _outboxMessages ??= $OutboxMessagesTable(this);
  OutboxMessageDao _outboxMessageDao;
  OutboxMessageDao get outboxMessageDao =>
      _outboxMessageDao ??= OutboxMessageDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [outboxMessages];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$OutboxMessageDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutboxMessagesTable get outboxMessages => db.outboxMessages;
}
