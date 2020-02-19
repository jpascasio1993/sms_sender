import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';

class OutboxPage extends StatefulWidget {
  OutboxPage({Key key}) : super(key: key);

  @override
  _OutboxPageState createState() => _OutboxPageState();
}

class _OutboxPageState extends State<OutboxPage> {
  OutboxBloc outboxBloc;
  final limit = -1;
  final offset = 0;
  @override
  void initState() {
    super.initState();
    outboxBloc = BlocProvider.of<OutboxBloc>(context);
  }

  void _onPress() {
    outboxBloc.add(GetOutboxEvent(limit: limit, offset: offset));
  }

  void _onPressSaveRemoteOutboxData() {
    outboxBloc.add(
        GetOutboxFromRemoteAndSaveToLocalEvent(limit: limit, offset: offset));
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
        return Center(
            child: Column(
          children: <Widget>[
            Text('Outbox', style: Theme.of(context).textTheme.display1),
            RaisedButton(
              onPressed: _onPress,
              child: const Text('GetOutboxEvent'),
            ),
            RaisedButton(
              onPressed: _onPressSaveRemoteOutboxData,
              child: const Text('GetOutboxFromRemoteAndSaveToLocalEvent'),
            ),
            Text('Count ${state.outboxList.length}')
          ],
        ));
      }),
    );
  }
}
