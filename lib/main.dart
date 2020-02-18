import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_version/get_version.dart';
import 'package:sms_sender/core/bloc/bloc_delegate.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/inbox/presentation/pages/inbox_page.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/outbox/presentation/pages/outbox_page.dart';
import './injectors.dart' as di;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imei_plugin/imei_plugin.dart';

// void main() => runApp(MyApp());


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final imei = await ImeiPlugin.getId();
  // final version = await GetVersion.appID;
  // debugPrint('imei ${imei}');
  // debugPrint('version ${version}');
  await di.init();
  Routes();
}


class Routes {
  Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => RootTab()
  };
  
  Routes() {
    BlocSupervisor.delegate = SimpleBlocDelegate();
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
  //Default guideline sizes are based on standard ~5" screen mobile device
  final int guidelineBaseWidth = 350;
  final int guidelineBaseHeight = 680;
  
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
    ScreenUtil.init(context, width: widget.guidelineBaseWidth, height: widget.guidelineBaseHeight);

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
          body: MultiBlocProvider(
            providers: [
              BlocProvider<InboxBloc>(create: (BuildContext context) =>  di.serviceLocator<InboxBloc>()),
              BlocProvider<OutboxBloc>(create: (BuildContext context) => di.serviceLocator<OutboxBloc>())
            ],
            child: TabBarView(
              children: <Widget>[InboxPage(), OutboxPage()],
            ), 
          )
        )
      );
   
  }
}