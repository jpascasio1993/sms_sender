import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sms_sender/screens/sms/index.dart';
import 'package:sms_sender/screens/outbox/index.dart';
import 'package:sms_sender/data/sms/index.dart' as SMSBloc;
import 'package:sms_sender/data/outbox/index.dart' as OutboxBloc;
import 'package:sms_sender/theme/style.dart';
import 'package:sms/sms.dart';

class Routes {
  Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => RootTab()
  };

  Routes() {
    SmsReceiver receiver = new SmsReceiver();
    receiver.onSmsReceived.listen((SmsMessage msg) => print(msg.body));
    runApp(MyApp(routes: routes));
  }
}

class RootTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 2,
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
                ),
                Tab(
                  key: UniqueKey(),
                  text: 'Outbox',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              BlocProvider<SMSBloc.SMSBloc>(
                  bloc: SMSBloc.SMSBloc(), child: SMSList()),
              BlocProvider<OutboxBloc.OutboxBloc>(
                  bloc: OutboxBloc.OutboxBloc(), child: OutboxList())
            ],
          ),
        ));
  }
}

class MyApp extends StatelessWidget {
  Map<String, WidgetBuilder> routes;

  MyApp({this.routes});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'SMS Sender App',
      theme: appTheme,
      routes: this.routes,
      initialRoute: '/',
    );
  }
}
// class MyApp extends StatefulWidget {
//   Map<String, WidgetBuilder> routes;

//   MyApp({this.routes});

//   @override
//   State<MyApp> createState() {
//     return MyAppState(routes: this.routes);
//   }
// }

// class MyAppState extends State<MyApp> {
//   Map<String, WidgetBuilder> routes;

//   MyAppState({this.routes});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SMS Sender App',
//       theme: appTheme,
//       routes: this.routes,
//       initialRoute: '/',
//     );
//     // return BlocProvider<SMSBloc.SMSBloc>(
//     //   bloc: SMSBloc.SMSBloc(),
//     //   child: MaterialApp(
//     //     title: 'SMS Sender App',
//     //     theme: appTheme,
//     //     routes: this.routes,
//     //     initialRoute: '/',
//     //   ),
//     // );
//   }
// }
