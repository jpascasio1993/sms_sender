import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sms_sender/core/widget/inherited_dependency.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/inbox/presentation/pages/inbox_page.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/outbox/presentation/pages/outbox_page.dart';
import './injectors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/permission/presentation/bloc/bloc.dart';
// void main() => runApp(MyApp());

void main() async {
  debugPrint = (String message, {int wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();
  // final imei = await ImeiPlugin.getId();
  // final version = await GetVersion.appID;
  // debugPrint('imei ${imei}');
  // debugPrint('version ${version}');
  // await di.Injector(mServiceLocator: GetIt.instance).init();
  Injector injector = Injector(serviceLocator: GetIt.instance);
  await injector.init();
  Routes(
    injector: injector
  );
}

class Routes {
  final Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => RootTab()
  };
  final Injector injector;
  Routes({@required this.injector}) {
    // BlocSupervisor.delegate = SimpleBlocDelegate();
    runApp(MyApp(routes: routes, injector: injector));
  }
}

class MyApp extends StatefulWidget {
  final Map<String, WidgetBuilder> routes;
  final Injector injector; 
  MyApp({Key key, @required this.routes, this.injector}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return InheritedDependency(
      child: MaterialApp(
        title: 'SMS Sender',
        routes: widget.routes,
        initialRoute: '/',
      ),
      injector: widget.injector
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
    ScreenUtil.init(context,
        width: widget.guidelineBaseWidth, height: widget.guidelineBaseHeight);
    final  serviceLocator = InheritedDependency.of(context).serviceLocator;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('SMS Sender'),
              centerTitle: true,
              bottom: TabBar(tabs: <Widget>[
                Tab(
                  key: UniqueKey(),
                  child: Text('Inbox',
                      style: TextStyle(fontSize: ScreenUtil().setSp(18))),
                ),
                Tab(
                    key: UniqueKey(),
                    child: Text('Outbox',
                        style: TextStyle(fontSize: ScreenUtil().setSp(18))))
              ]),
            ),
            body: MultiBlocProvider(
              providers: [
                BlocProvider<InboxBloc>(
                    create: (BuildContext context) =>
                        serviceLocator<InboxBloc>()),
                BlocProvider<OutboxBloc>(
                    create: (BuildContext context) =>
                        serviceLocator<OutboxBloc>()),
                BlocProvider<PermissionBloc>(
                    create: (BuildContext context) =>
                        serviceLocator<PermissionBloc>())
              ],
              child: TabBarView(
                children: <Widget>[
                  InboxPage(key: PageStorageKey('inbox_tab')),
                  OutboxPage(key: PageStorageKey('outbox_tab'))
                ],
              ),
            )));
  }
}
