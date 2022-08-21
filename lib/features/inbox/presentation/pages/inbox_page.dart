import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/permission/presentation/bloc/bloc.dart';
import 'package:sms_sender/core/global/theme.dart' as theme;
import 'package:edge_alert/edge_alert.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:sms_sender/core/database/database.dart' as moordb;
import 'package:sms_sender/tasks.dart';

class InboxPage extends StatefulWidget {
  InboxPage({Key key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage>
    with AutomaticKeepAliveClientMixin<InboxPage>, WidgetsBindingObserver{
  InboxBloc inboxBloc;
  PermissionBloc permissionBloc;
  final ScrollController _scrollController = ScrollController();
  final ReceivePort _foregroundPort = ReceivePort();
  final PageStorageKey storageKey = PageStorageKey('sms_list_view');
  final limit = 30;
  final offset = 0;
  final _scrollThreshold = 200.0;
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    debugPrint('inbox initState');
    WidgetsBinding.instance.addObserver(this);
    _initPlatformState();
    inboxBloc = BlocProvider.of<InboxBloc>(context);
    permissionBloc = BlocProvider.of<PermissionBloc>(context);
    _initScrolLListener();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPermission());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('InboxPage didChangeDependencies');
    themeData = Theme.of(context).copyWith(dividerColor: Colors.transparent);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // Remove the port mapping just in case the UI is shutting down but
    // background isolate is continuing to run.
    IsolateNameServer.removePortNameMapping(PROCESS_INBOX_PORT_NAME);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      _initPermission();
    }
  }

  void _initPlatformState() {
    IsolateNameServer.removePortNameMapping(PROCESS_INBOX_PORT_NAME);
    // The IsolateNameServer allows for us to create a mapping between a String
    // and a SendPort that is managed by the Flutter engine. A SendPort can
    // then be looked up elsewhere, like a background callback, to establish
    // communication channels between isolates that were not spawned by one
    // another.
    if (!IsolateNameServer.registerPortWithName(
        _foregroundPort.sendPort, PROCESS_INBOX_PORT_NAME)) {
      //name entry already exists
      debugPrint('Unable to register inbox port!');
    }

    _foregroundPort.listen((dynamic message) {
      final Map<String, dynamic> data = message;
      switch (data['action']) {
       
        case SUCCESS_REFETCH_INBOX:
            _refetchInbox();
          break;
        default:
          break;
      }
    }, onDone: () {});
  }
  
  void _onGetInbox() {
    inboxBloc.add(GetInboxEvent(limit: limit, offset: offset));
  }

  void _refetchInbox() {
    final currentLimit = inboxBloc.state.inboxList.length > 25 ? inboxBloc.state.inboxList.length : limit;
     inboxBloc.add(GetInboxEvent(limit: currentLimit, offset: offset));
  }

  void _onPressSaveSms() {
    inboxBloc.add(GetSmsAndSaveToDbEvent(
        limit: 10, offset: inboxBloc.state.inboxList.length));
  }

  void _initPermission() {
    permissionBloc.add(RequestPermissionEvent(permissions: [
      PermissionGroup.sms,
      PermissionGroup.phone,
      PermissionGroup.contacts,
      PermissionGroup.storage
    ]));
  }

  void _initScrolLListener() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if(currentScroll == maxScroll) {
      // if (maxScroll - currentScroll <= _scrollThreshold) {
        inboxBloc.add(GetMoreInboxEvent(
            limit: limit, offset: inboxBloc.state.inboxList.length));
      }
    });
  }

  void _onPressTest() async {
    await processInbox();
  }

  Map<String, dynamic> getStatus(int status) {
    if (status == InboxStatus.processed) {
      return {'color': Colors.greenAccent, 'label': 'PROCESSED'};
    } else if (status == InboxStatus.failed) {
      return {'color': Colors.redAccent, 'label': 'FAILED'};
    } else if (status == InboxStatus.reprocess) {
      return {'color': Colors.purpleAccent, 'label': 'REPROCESS'};
    } else {
      return {'color': Colors.redAccent, 'label': 'UNPROCESSED'};
    }
  }

  void _onUpdate({@required InboxMessage inbox, @required int status}) {
    inboxBloc.add(InboxUpdateEvent(messages: [
      moordb.InboxMessagesCompanion.insert(
          id: moor.Value(inbox.id),
          body: moor.Value(inbox.body),
          date: moor.Value(inbox.date),
          address: moor.Value(inbox.address),
          dateSent: moor.Value(inbox.dateSent),
          status: moor.Value(status))
    ], limit: inboxBloc.state.inboxList.length, offset: 0));
  }

  void _onDelete({@required InboxMessage inbox}) {
    inboxBloc.add(InboxDeleteEvent(messages: [
      moordb.InboxMessagesCompanion.insert(
        id: moor.Value(inbox.id),
      )
    ], limit: inboxBloc.state.inboxList.length, offset: 0));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
        listeners: [
          BlocListener<PermissionBloc, PermissionState>(
              listener: (BuildContext context, PermissionState state) {
            if (state is PermissionGrantedState) {
              _onGetInbox();
            }
          }),
          BlocListener<InboxBloc, InboxState>(
              listener: (BuildContext context, InboxState state) {
            if (state is RetrievedInboxState) {
              debugPrint('inboxList size ${state.inboxList.length}');
            } else if (state is InboxErrorUpdateState) {
              EdgeAlert.show(context,
                  title: 'Inbox',
                  icon: Icons.error,
                  backgroundColor: Colors.redAccent,
                  description: state.message,
                  gravity: EdgeAlert.TOP);
            }
          })
        ],
        child: BlocBuilder<PermissionBloc, PermissionState>(
          builder: (BuildContext context, PermissionState state) {
            if(state is PermissionGrantedState) {
              return BlocBuilder<InboxBloc, InboxState>(
                        builder: (BuildContext context, InboxState state) {
                      // if (state is RetrievedInboxState || state is InboxLoadingState) {
                      if (state.inboxList.isEmpty) {
                        return Center(key: UniqueKey(), child: const Text('No Data'));
                      }

                      return ListView.builder(
                          controller: _scrollController,
                          key: storageKey,
                          itemCount: state.inboxList.length,
                          itemBuilder: (BuildContext context, int index) {
                            InboxMessage inbox = state.inboxList[index];
                            Map<String, dynamic> status = getStatus(inbox.status);
                            MaterialAccentColor statusColor = status['color'];
                            String statusLabel = status['label'];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Theme(
                                  data: themeData,
                                  child: ExpansionTile(
                                    key: PageStorageKey('inbox_${inbox.id}'),
                                    title: Padding(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setSp(10),
                                          bottom: ScreenUtil().setSp(10)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: ScreenUtil().setSp(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    inbox.address,
                                                    style: theme.dateStyle,
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: ScreenUtil().setSp(10),
                                                        right: ScreenUtil().setSp(10)),
                                                    decoration: BoxDecoration(
                                                        border:
                                                            Border.all(color: statusColor),
                                                        borderRadius: BorderRadius.circular(
                                                            ScreenUtil().setSp(2)),
                                                        color: statusColor),
                                                    child: Text(
                                                      statusLabel,
                                                      style: theme.textWhiteStyle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(inbox.body),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenUtil().setSp(10)),
                                              child:
                                                  Text(inbox.date, style: theme.dateStyle)),
                                        ],
                                      ),
                                    ),
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          FlatButton.icon(
                                              icon: Icon(
                                                Icons.send,
                                                color: Colors.blueAccent,
                                              ),
                                              label: Text(
                                                'Reprocess',
                                                style: theme.positiveStyle,
                                              ),
                                              onPressed: () => _onUpdate(
                                                  inbox: inbox,
                                                  status: InboxStatus.reprocess)),
                                          Visibility(
                                            visible: false,
                                            child: FlatButton.icon(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              label: Text('Delete', style: theme.textStyle),
                                              onPressed: () => _onDelete(inbox: inbox)
                                            ),
                                          ),
                                          // IconButton(
                                          //   icon: Icon(Icons.launch),
                                          //   onPressed: () {},
                                          // )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  key: PageStorageKey('inbox_${inbox.id}_divider'),
                                )
                              ],
                            );
                          });
                    }
                        // else if (state is InboxErrorState) {
                        //   return Center(
                        //       key: UniqueKey(),
                        //       child: const Text(
                        //           'Failed to retrieve data. Something went wrong'));
                        // } else {
                        //   return Center(key: UniqueKey(), child: const Text('No Data'));
                        // }
                        //}
                  );
            }
            else {
              return Center(
                child: Text("Permission Denied!", style: theme.textStyle),
              );
            }
          }
        )
      );
  }
}



