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
  final int status;
  OutboxMessage(
      {@required this.id,
      this.title,
      this.body,
      this.recipient,
      this.date,
      @required this.status});
  factory OutboxMessage.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return OutboxMessage(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      recipient: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}recipient']),
      date: stringType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      status: intType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
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
      status: serializer.fromJson<int>(json['status']),
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
      'status': serializer.toJson<int>(status),
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
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  OutboxMessage copyWith(
          {int id,
          String title,
          String body,
          String recipient,
          String date,
          int status}) =>
      OutboxMessage(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        recipient: recipient ?? this.recipient,
        date: date ?? this.date,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('OutboxMessage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('recipient: $recipient, ')
          ..write('date: $date, ')
          ..write('status: $status')
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
              $mrjc(recipient.hashCode,
                  $mrjc(date.hashCode, status.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is OutboxMessage &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.recipient == this.recipient &&
          other.date == this.date &&
          other.status == this.status);
}

class OutboxMessagesCompanion extends UpdateCompanion<OutboxMessage> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> recipient;
  final Value<String> date;
  final Value<int> status;
  const OutboxMessagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.recipient = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
  });
  OutboxMessagesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.recipient = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
  });
  OutboxMessagesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String> recipient,
      Value<String> date,
      Value<int> status}) {
    return OutboxMessagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      recipient: recipient ?? this.recipient,
      date: date ?? this.date,
      status: status ?? this.status,
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
      true,
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
      true,
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
      true,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;
  @override
  GeneratedTextColumn get date => _date ??= _constructDate();
  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedIntColumn _status;
  @override
  GeneratedIntColumn get status => _status ??= _constructStatus();
  GeneratedIntColumn _constructStatus() {
    return GeneratedIntColumn('status', $tableName, false,
        defaultValue: Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, title, body, recipient, date, status];
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
    }
    if (d.body.present) {
      context.handle(
          _bodyMeta, body.isAcceptableValue(d.body.value, _bodyMeta));
    }
    if (d.recipient.present) {
      context.handle(_recipientMeta,
          recipient.isAcceptableValue(d.recipient.value, _recipientMeta));
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    }
    if (d.status.present) {
      context.handle(
          _statusMeta, status.isAcceptableValue(d.status.value, _statusMeta));
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
      map['date'] = Variable<String, StringType>(d.date.value);
    }
    if (d.status.present) {
      map['status'] = Variable<int, IntType>(d.status.value);
    }
    return map;
  }

  @override
  $OutboxMessagesTable createAlias(String alias) {
    return $OutboxMessagesTable(_db, alias);
  }
}

class InboxMessage extends DataClass implements Insertable<InboxMessage> {
  final int id;
  final String address;
  final String body;
  final String date;
  final String dateSent;
  final int status;
  InboxMessage(
      {@required this.id,
      this.address,
      this.body,
      this.date,
      this.dateSent,
      @required this.status});
  factory InboxMessage.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return InboxMessage(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      address:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}address']),
      body: stringType.mapFromDatabaseResponse(data['${effectivePrefix}body']),
      date: stringType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      dateSent: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}date_sent']),
      status: intType.mapFromDatabaseResponse(data['${effectivePrefix}status']),
    );
  }
  factory InboxMessage.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return InboxMessage(
      id: serializer.fromJson<int>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      body: serializer.fromJson<String>(json['body']),
      date: serializer.fromJson<String>(json['date']),
      dateSent: serializer.fromJson<String>(json['dateSent']),
      status: serializer.fromJson<int>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'address': serializer.toJson<String>(address),
      'body': serializer.toJson<String>(body),
      'date': serializer.toJson<String>(date),
      'dateSent': serializer.toJson<String>(dateSent),
      'status': serializer.toJson<int>(status),
    };
  }

  Map<String, dynamic> toPostMap({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic> {
      '"_id"': '"${serializer.toJson<int>(id)}"',
      '"sender_number"': '"${serializer.toJson<String>(address)}"',
      '"message"': '"${serializer.toJson<String>(body).toString().replaceAll('"', '\\"')}"',
      '"date_time"': '"${serializer.toJson<String>(date)}"',
      '"status"': '"${serializer.toJson<int>(status)}"'
    };
  }
  @override
  InboxMessagesCompanion createCompanion(bool nullToAbsent) {
    return InboxMessagesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      dateSent: dateSent == null && nullToAbsent
          ? const Value.absent()
          : Value(dateSent),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
    );
  }

  InboxMessage copyWith(
          {int id,
          String address,
          String body,
          String date,
          String dateSent,
          int status}) =>
      InboxMessage(
        id: id ?? this.id,
        address: address ?? this.address,
        body: body ?? this.body,
        date: date ?? this.date,
        dateSent: dateSent ?? this.dateSent,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('InboxMessage(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('body: $body, ')
          ..write('date: $date, ')
          ..write('dateSent: $dateSent, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          address.hashCode,
          $mrjc(
              body.hashCode,
              $mrjc(
                  date.hashCode, $mrjc(dateSent.hashCode, status.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is InboxMessage &&
          other.id == this.id &&
          other.address == this.address &&
          other.body == this.body &&
          other.date == this.date &&
          other.dateSent == this.dateSent &&
          other.status == this.status);
}

class InboxMessagesCompanion extends UpdateCompanion<InboxMessage> {
  final Value<int> id;
  final Value<String> address;
  final Value<String> body;
  final Value<String> date;
  final Value<String> dateSent;
  final Value<int> status;
  const InboxMessagesCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.body = const Value.absent(),
    this.date = const Value.absent(),
    this.dateSent = const Value.absent(),
    this.status = const Value.absent(),
  });
  InboxMessagesCompanion.insert({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.body = const Value.absent(),
    this.date = const Value.absent(),
    this.dateSent = const Value.absent(),
    this.status = const Value.absent(),
  });
  InboxMessagesCompanion copyWith(
      {Value<int> id,
      Value<String> address,
      Value<String> body,
      Value<String> date,
      Value<String> dateSent,
      Value<int> status}) {
    return InboxMessagesCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      body: body ?? this.body,
      date: date ?? this.date,
      dateSent: dateSent ?? this.dateSent,
      status: status ?? this.status,
    );
  }
}

class $InboxMessagesTable extends InboxMessages
    with TableInfo<$InboxMessagesTable, InboxMessage> {
  final GeneratedDatabase _db;
  final String _alias;
  $InboxMessagesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _addressMeta = const VerificationMeta('address');
  GeneratedTextColumn _address;
  @override
  GeneratedTextColumn get address => _address ??= _constructAddress();
  GeneratedTextColumn _constructAddress() {
    return GeneratedTextColumn(
      'address',
      $tableName,
      true,
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
      true,
    );
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedTextColumn _date;
  @override
  GeneratedTextColumn get date => _date ??= _constructDate();
  GeneratedTextColumn _constructDate() {
    return GeneratedTextColumn(
      'date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _dateSentMeta = const VerificationMeta('dateSent');
  GeneratedTextColumn _dateSent;
  @override
  GeneratedTextColumn get dateSent => _dateSent ??= _constructDateSent();
  GeneratedTextColumn _constructDateSent() {
    return GeneratedTextColumn(
      'date_sent',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedIntColumn _status;
  @override
  GeneratedIntColumn get status => _status ??= _constructStatus();
  GeneratedIntColumn _constructStatus() {
    return GeneratedIntColumn('status', $tableName, false,
        defaultValue: Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, address, body, date, dateSent, status];
  @override
  $InboxMessagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'inbox_messages';
  @override
  final String actualTableName = 'inbox_messages';
  @override
  VerificationContext validateIntegrity(InboxMessagesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.address.present) {
      context.handle(_addressMeta,
          address.isAcceptableValue(d.address.value, _addressMeta));
    }
    if (d.body.present) {
      context.handle(
          _bodyMeta, body.isAcceptableValue(d.body.value, _bodyMeta));
    }
    if (d.date.present) {
      context.handle(
          _dateMeta, date.isAcceptableValue(d.date.value, _dateMeta));
    }
    if (d.dateSent.present) {
      context.handle(_dateSentMeta,
          dateSent.isAcceptableValue(d.dateSent.value, _dateSentMeta));
    }
    if (d.status.present) {
      context.handle(
          _statusMeta, status.isAcceptableValue(d.status.value, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InboxMessage map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return InboxMessage.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(InboxMessagesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.address.present) {
      map['address'] = Variable<String, StringType>(d.address.value);
    }
    if (d.body.present) {
      map['body'] = Variable<String, StringType>(d.body.value);
    }
    if (d.date.present) {
      map['date'] = Variable<String, StringType>(d.date.value);
    }
    if (d.dateSent.present) {
      map['date_sent'] = Variable<String, StringType>(d.dateSent.value);
    }
    if (d.status.present) {
      map['status'] = Variable<int, IntType>(d.status.value);
    }
    return map;
  }

  @override
  $InboxMessagesTable createAlias(String alias) {
    return $InboxMessagesTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $OutboxMessagesTable _outboxMessages;
  $OutboxMessagesTable get outboxMessages =>
      _outboxMessages ??= $OutboxMessagesTable(this);
  $InboxMessagesTable _inboxMessages;
  $InboxMessagesTable get inboxMessages =>
      _inboxMessages ??= $InboxMessagesTable(this);
  OutboxMessageDao _outboxMessageDao;
  OutboxMessageDao get outboxMessageDao =>
      _outboxMessageDao ??= OutboxMessageDao(this as AppDatabase);
  InboxMessageDao _inboxMessageDao;
  InboxMessageDao get inboxMessageDao =>
      _inboxMessageDao ??= InboxMessageDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [outboxMessages, inboxMessages];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$OutboxMessageDaoMixin on DatabaseAccessor<AppDatabase> {
  $OutboxMessagesTable get outboxMessages => db.outboxMessages;
}
mixin _$InboxMessageDaoMixin on DatabaseAccessor<AppDatabase> {
  $InboxMessagesTable get inboxMessages => db.inboxMessages;
}
