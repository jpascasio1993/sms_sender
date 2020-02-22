import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:sms_sender/injectors.dart';

class InheritedDependency extends InheritedWidget {
  final Widget child;
  final Injector _injector;
  InheritedDependency({Key key, this.child, @required Injector injector}): _injector = injector, super(key: key, child: child);

  static InheritedDependency of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedDependency>();
  }
  
  GetIt get serviceLocator => _injector.serviceLocator;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

}