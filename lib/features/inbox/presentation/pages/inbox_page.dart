import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/permission/presentation/bloc/bloc.dart';
import 'package:sms_sender/core/global/theme.dart' as theme;

class InboxPage extends StatefulWidget {
  InboxPage({Key key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with AutomaticKeepAliveClientMixin<InboxPage> {
  InboxBloc inboxBloc;
  PermissionBloc permissionBloc;
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey storageKey = PageStorageKey('sms_list_view');
  final limit = 30;
  final offset = 0;
  final _scrollThreshold = 200.0;
  ThemeData themeData;
  
  @override
  void initState() {
    super.initState();
    inboxBloc = BlocProvider.of<InboxBloc>(context);
    permissionBloc = BlocProvider.of<PermissionBloc>(context);
     _initScrolLListener();
     WidgetsBinding.instance.addPostFrameCallback(
        (_) => _initPermission());
     
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('OutboxPage didChangeDependencies');
    themeData = Theme.of(context).copyWith(dividerColor: Colors.transparent);
  }

  @override
  bool get wantKeepAlive => true;

  void _onGetInbox() {
    inboxBloc.add(GetInboxEvent(limit: limit, offset: offset));
  }

  void _onPressSaveSms() {
    inboxBloc.add(GetSmsAndSaveToDbEvent(
        limit: 10, offset: inboxBloc.state.inboxList.length));
  }

  void _initPermission() {
    permissionBloc.add(RequestPermissionEvent(permissions: [
      PermissionGroup.sms,
      PermissionGroup.phone,
      PermissionGroup.contacts
    ]));
  }

  void _initScrolLListener() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        //appManager.outboxMessagesFromDb();
        inboxBloc.add(GetMoreInboxEvent(limit: limit, offset: inboxBloc.state.inboxList.length));
      }
    });
  }

  Map<String, dynamic> getStatus(int status) {
    if(status == InboxStatus.processed) {
       return {'color': Colors.greenAccent, 'label': 'PROCESSED'};
    }
    else if(status == InboxStatus.failed) { 
      return {'color': Colors.redAccent, 'label': 'FAILED'};
    }
    else if(status == InboxStatus.reprocess) {
      return {'color': Colors.purpleAccent, 'label': 'REPROCESS'};
    }
    else {
      return {'color': Colors.redAccent, 'label': 'UNPROCESSED'};
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocListener(listeners: [
      BlocListener<PermissionBloc, PermissionState>(
        listener: (BuildContext context, PermissionState state) {
            if(state is PermissionGrantedState) {
              _onGetInbox();
            }
        }
      ),
      BlocListener<InboxBloc, InboxState>(
        listener: (BuildContext context, InboxState state) {
            if (state is RetrievedInboxState) {
              debugPrint('inboxList size ${state.inboxList.length}');
            }
        }
      )
    ], child: BlocBuilder<InboxBloc, InboxState>(
          builder: (BuildContext context, InboxState state) {

        if(state is RetrievedInboxState || state is InboxLoadingState) {
              
              if(state.inboxList.isEmpty) {
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
                          key: PageStorageKey('${inbox.id}'),
                          title: Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setSp(10), bottom: ScreenUtil().setSp(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: ScreenUtil().setSp(10)),
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
                                              left: ScreenUtil().setSp(10), right: ScreenUtil().setSp(10)),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: statusColor),
                                              borderRadius:
                                                  BorderRadius.circular(ScreenUtil().setSp(2)),
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
                                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
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
                                    onPressed: (){}
                                    ),
                                Visibility(
                                  visible: false,
                                  child: FlatButton.icon(
                                    icon:
                                        Icon(Icons.delete, color: Colors.redAccent),
                                    label: Text('Delete', style: theme.textStyle),
                                    onPressed: () {},
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
                      )
                    ],
                  );
                }
              );
          }
          else if(state is InboxErrorState) {
            return Center(
              key: UniqueKey(),
              child: const Text('Failed to retrieve data. Something went wrong'));
          }
          else {
            return Center(key: UniqueKey(), child: const Text('No Data'));
          }
      })
    );
  }
}
