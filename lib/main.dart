import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/core/widget/inherited_dependency.dart';
import 'package:sms_sender/features/inbox/domain/usecases/count_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/inbox/presentation/pages/inbox_page.dart';
import 'package:sms_sender/features/outbox/domain/usecases/count_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
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
    // return InheritedDependency(
    //   child: MaterialApp(
    //     title: 'SMS Sender',
    //     routes: widget.routes,
    //     initialRoute: '/',
    //   ),
    //   injector: widget.injector
    // );
    final serviceLocator = widget.injector.serviceLocator;
    return MultiBlocProvider(
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
      child: InheritedDependency(
          child: MaterialApp(
            title: 'SMS Sender',
            routes: widget.routes,
            initialRoute: '/',
          ),
          injector: widget.injector
        )  
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
  int selectedTabIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _onTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void _onActionTap(BuildContext context) async {
    final serviceLocator = InheritedDependency.of(context).serviceLocator;
    final CountInbox countInbox = serviceLocator<CountInbox>();
    final CountOutbox countOutbox = serviceLocator<CountOutbox>();
    
    final pending = selectedTabIndex == 1 ? await countOutbox(OutboxParams(status: [OutboxStatus.resend, OutboxStatus.unsent, OutboxStatus.failed]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    )): await countInbox(InboxParams(status: [InboxStatus.unprocessed, InboxStatus.reprocess, InboxStatus.failed]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    ));
    
    final total = selectedTabIndex == 1 ? await countOutbox(OutboxParams(status: [OutboxStatus.unsent, OutboxStatus.sent, OutboxStatus.resend, OutboxStatus.failed]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    )) : await countInbox(InboxParams(status: [InboxStatus.unprocessed, InboxStatus.reprocess, InboxStatus.processed, InboxStatus.failed]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    ));
    
    final sent = selectedTabIndex == 1 ? await countOutbox(OutboxParams(status: [OutboxStatus.sent]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    )) : await countInbox(InboxParams(status: [InboxStatus.processed]))
    .then((res) => res.fold(
      (failure) => 0,
      (count) => count
    ));

    FlatButton positiveButton = FlatButton(
      onPressed: () {
        Navigator.pop(context);
      }, 
      child: Text('Close')
    );

    AlertDialog dialog = AlertDialog(
      title: Text('${selectedTabIndex == 1 ? 'Outbox': 'Inbox'} Information'),
      content: DataTable(
        columns: [
          DataColumn(label: Text('Status', style: TextStyle( fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Count', style: TextStyle( fontWeight: FontWeight.bold)), numeric: true)
        ], 
        rows: [
          DataRow(
            selected: false,
            cells: [
              DataCell(
                Text('Pending', style: TextStyle( color: Colors.orangeAccent)),
              ),
              DataCell(
                Text('$pending', style: TextStyle( fontWeight: FontWeight.bold)),
                onTap: null
              )
            ]
          ),
          DataRow(
            selected: false,
            cells: [
              DataCell(
                Text('Sent', style: TextStyle( color: Colors.greenAccent)),
                onTap: null
              ),
              DataCell(
                Text('$sent', style: TextStyle( fontWeight: FontWeight.bold)),
                onTap: null
              )
            ]
          ),
          DataRow(
            selected: false,
            cells: [
              DataCell(
                Text('Total', style: TextStyle( color: Colors.purpleAccent)),
              ),
              DataCell(
                Text('$total', style: TextStyle( fontWeight: FontWeight.bold)),
                onTap: null
              )
            ]
          )
        ]
      ),
      actions: <Widget>[
        positiveButton
      ],
    );
    showDialog(context: context, child: dialog);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: widget.guidelineBaseWidth, height: widget.guidelineBaseHeight);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('SMS Sender'),
              actions: <Widget>[
                Padding(
                  child: GestureDetector(
                    child: Icon(
                      Icons.info_outline,
                      size: 26
                    ),
                    onTap: () {
                      _onActionTap(context);
                    }
                  ),
                  padding: EdgeInsets.all(14),
                )
              ],
              centerTitle: true,
              bottom: TabBar(
                onTap: _onTabTap,
                tabs: <Widget>[
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
            body: TabBarView(
                children: <Widget>[
                  InboxPage(key: PageStorageKey('inbox_tab')),
                  OutboxPage(key: PageStorageKey('outbox_tab'))
                ],
              )
            )
          );
  }
}
