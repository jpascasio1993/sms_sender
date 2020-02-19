import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'package:sms_sender/features/permission/presentation/bloc/bloc.dart';

class InboxPage extends StatefulWidget {
  InboxPage({Key key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  InboxBloc inboxBloc;
  PermissionBloc permissionBloc;

  final limit = -1;
  final offset = 0;
  @override
  void initState() {
    super.initState();
    inboxBloc = BlocProvider.of<InboxBloc>(context);
    permissionBloc = BlocProvider.of<PermissionBloc>(context);
  }

  void _onPress() {
    inboxBloc.add(GetInboxEvent(limit: limit, offset: offset));
  }

  void _onPressSaveSms() {
    inboxBloc.add(GetSmsAndSaveToDbEvent(
        limit: 10, offset: inboxBloc.state.inboxList.length));
  }

  void _onPressPermission() {
    permissionBloc.add(RequestPermissionEvent(permissions: [
      PermissionGroup.sms,
      PermissionGroup.phone,
      PermissionGroup.contacts
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InboxBloc, InboxState>(
      listener: (BuildContext context, InboxState state) {
        if (state is RetrievedInboxState) {
          debugPrint('outboxlist size ${state.inboxList.length}');
        }
      },
      child: BlocBuilder<InboxBloc, InboxState>(
          builder: (BuildContext context, InboxState state) {
        return Center(
            child: Column(
          children: <Widget>[
            Text('Inbox', style: Theme.of(context).textTheme.display1),
            RaisedButton(
              onPressed: _onPress,
              child: const Text('GetInboxEvent'),
            ),
            RaisedButton(
              onPressed: _onPressSaveSms,
              child: const Text('GetSMSAndSaveToDB'),
            ),
            RaisedButton(
              onPressed: _onPressPermission,
              child: const Text('Permission'),
            )
          ],
        ));
      }),
    );
  }
}
