import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/core/global/theme.dart' as theme;

class OutboxPage extends StatefulWidget {
  OutboxPage({Key key}) : super(key: key);

  @override
  _OutboxPageState createState() => _OutboxPageState();
}

class _OutboxPageState extends State<OutboxPage> with AutomaticKeepAliveClientMixin<OutboxPage> {
  OutboxBloc outboxBloc;
  final limit = 30;
  final offset = 0;
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey storageKey = PageStorageKey('outbox_list_view');
  final _scrollThreshold = 200.0;
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    outboxBloc = BlocProvider.of<OutboxBloc>(context);
    _initScrolLListener();
     WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onPress());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('OutboxPage didChangeDependencies');
    themeData = Theme.of(context).copyWith(dividerColor: Colors.transparent);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onPress() {
    outboxBloc.add(GetOutboxEvent(limit: limit, offset: outboxBloc.state.outboxList.length));
  }

  void _onPressSaveRemoteOutboxData() {
    outboxBloc.add(
        GetOutboxFromRemoteAndSaveToLocalEvent(limit: limit, offset: offset));
  }

  Map<String, dynamic> getStatus(int status) {
    if(status == OutboxStatus.sent) {
       return {'color': Colors.greenAccent, 'label': 'SENT'};
    }
    else if(status == OutboxStatus.failed) { 
      return {'color': Colors.redAccent, 'label': 'FAILED'};
    }
    else if(status == OutboxStatus.resend) {
      return {'color': Colors.purpleAccent, 'label': 'RESENDING'};
    }
    else {
      return {'color': Colors.redAccent, 'label': 'PENDING'};
    }
  }

  void _initScrolLListener() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        //appManager.outboxMessagesFromDb();
        outboxBloc.add(GetMoreOutboxEvent(limit: limit, offset: outboxBloc.state.outboxList.length));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocListener<OutboxBloc, OutboxState>(
      listener: (BuildContext context, OutboxState state) {
        if (state is RetrievedOutboxState) {
          debugPrint('outboxlist size ${state.outboxList.length}');
        }
      },
      child: BlocBuilder<OutboxBloc, OutboxState>(
        builder: (BuildContext context, OutboxState state) {

          if(state is RetrievedOutboxState || state is OutboxLoadingState) {
              
              if(state.outboxList.isEmpty) {
                return Center(key: UniqueKey(), child: const Text('No Data'));
              }

              return ListView.builder(
                controller: _scrollController,
                key: storageKey,
                itemCount: state.outboxList.length,
                itemBuilder: (BuildContext context, int index) {
                  OutboxModel outbox = state.outboxList[index];
                  Map<String, dynamic> status = getStatus(outbox.status);
                  MaterialAccentColor statusColor = status['color'];
                  String statusLabel = status['label'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Theme(
                        data: themeData,
                        child: ExpansionTile(
                          key: PageStorageKey('${outbox.id}'),
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
                                          outbox.recipient,
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
                                Text(outbox.body),
                                Padding(
                                    padding: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                    child:
                                        Text(outbox.date, style: theme.dateStyle)),
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
                                        'Re-Send',
                                        style: theme.positiveStyle,
                                      ),
                                    onPressed: _onPress
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
          else if(state is OutboxErrorState) {
            return Center(
              key: UniqueKey(),
              child: const Text('Failed to retrieve data. Something went wrong'));
          }
          else {
            return Center(key: UniqueKey(), child: const Text('No Data'));
          }
        }),
    );
  }
}
