import 'package:flutter/material.dart';
import 'package:sms_sender/features/inbox/presentation/pages/inbox_page.dart';
import 'package:sms_sender/features/outbox/presentation/pages/outbox_page.dart';
import './injectors.dart' as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';
// void main() => runApp(MyApp());


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  Routes();
}


class Routes {
  Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => RootTab()
  };
  
  Routes() {
    runApp(MyApp(routes: routes));
  }
}
class MyApp extends StatefulWidget {
  final Map<String, WidgetBuilder> routes;

  MyApp({Key key, @required this.routes}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Sender',
      routes: widget.routes,
      initialRoute: '/',
    );
  }
}


class RootTab extends StatefulWidget {
  RootTab({Key key}) : super(key: key);

  @override
  _RootTabState createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 350, height: 680);
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMS Sender'),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                key: UniqueKey(),
                child: Text('inbox', style: TextStyle(fontSize: ScreenUtil().setSp(16))),
              ),
              Tab(
                key: UniqueKey(),
                text: 'Outbox'
              )
            ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[InboxPage(), OutboxPage()],
        ),
      )
    );
  }
}