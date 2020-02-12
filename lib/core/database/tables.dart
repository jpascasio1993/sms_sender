import 'package:moor_flutter/moor_flutter.dart';

class OutboxMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get recipient => text()();
  TextColumn get date => text()();
  BoolColumn get sent => boolean().withDefault(Constant(false))(); 
}

class InboxMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get address => text()();
  TextColumn get body => text()();
  TextColumn get date => text()();
  TextColumn get dateSent => text()();
  BoolColumn get sent => boolean().withDefault(Constant(false))();
}
