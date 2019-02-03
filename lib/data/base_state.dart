import 'package:equatable/equatable.dart';

abstract class BaseState<T> extends Equatable {
  T data;
  BaseState({this.data});
  bool get isRefetch => false;
}
