import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sms_sender/screens/sms/index.dart';
import 'package:sms_sender/data/sms/index.dart' as SMSBloc;
import 'package:sms_sender/theme/style.dart';

class Routes {
  Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => RootTab()
  };

  Routes() {
    runApp(MyApp(routes: routes));
  }
}

class RootTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text('SMS Sender'),
            centerTitle: true,
            bottom: TabBar(
              labelStyle: tabLabelStyle,
              tabs: <Widget>[
                Tab(
                  key: UniqueKey(),
                  text: 'Inbox',
                )
              ],
            ),
          ),
          body: SMSList(),
        ));
  }
}

class MyApp extends StatefulWidget {
  Map<String, WidgetBuilder> routes;

  MyApp({this.routes});

  @override
  State<MyApp> createState() {
    // TODO: implement createState
    return MyAppState(routes: this.routes);
  }
}

class MyAppState extends State<MyApp> {
  Map<String, WidgetBuilder> routes;

  MyAppState({this.routes});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SMSBloc.SMSBloc>(
      bloc: SMSBloc.SMSBloc(),
      child: MaterialApp(
        title: 'SMS Sender App',
        theme: appTheme,
        routes: this.routes,
        initialRoute: '/',
      ),
    );
  }
}
