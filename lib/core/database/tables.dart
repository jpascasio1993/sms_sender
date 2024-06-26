import 'package:moor_flutter/moor_flutter.dart';

class OutboxMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text().nullable()();
  TextColumn get recipient => text().nullable()();
  TextColumn get date => text().nullable()();
  // BoolColumn get sent => boolean().withDefault(Constant(false))(); 
  IntColumn get status => integer().withDefault(Constant(0))();
  IntColumn get priority => integer().withDefault(Constant(0))();
}

class InboxMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text().nullable()();
  TextColumn get body => text().nullable()();
  TextColumn get date => text().nullable()();
  TextColumn get dateSent => text().nullable()();
  // BoolColumn get sent => boolean().withDefault(Constant(false))();
  IntColumn get status => integer().withDefault(Constant(0))();
  IntColumn get priority => integer().withDefault(Constant(0))();
}
