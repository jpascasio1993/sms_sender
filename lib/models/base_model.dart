import 'package:meta/meta.dart';
import 'dart:collection';

abstract class BaseModel<T> {
  List<T> _results = [];
  List<T> get results => _results;
  BaseModel();
  BaseModel.clone({@required BaseModel item}) {
    if (item != null) _results = List.from(item.results);
  }
}
