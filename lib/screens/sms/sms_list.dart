import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_sender/data/sms/index.dart';
import 'package:sms_sender/theme/style.dart' as theme;

class SMSList extends StatefulWidget {
  _SMSListState createState() => _SMSListState();
}

class _SMSListState extends State<SMSList> {
  SMSBloc bloc;
  ThemeData themeData;
  @override
  void didChangeDependencies() {
    bloc = BlocProvider.of<SMSBloc>(context);
    themeData = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    super.didChangeDependencies();
  }

  MaterialAccentColor getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "processed":
        return Colors.indigoAccent;
      case "pending":
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: bloc,
        builder: (BuildContext context, SMSState state) {
          //print('List ${state.data}');
          print('smslist build');
          return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (BuildContext context, int index) {
              MaterialAccentColor statusColor = getStatusColor('processed');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Theme(
                    //override expansiontile props through theme
                    data: themeData,
                    child: ExpansionTile(
                      title: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '2018-11-30 6:30PM',
                                    style: theme.dateStyle,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: statusColor),
                                        borderRadius: BorderRadius.circular(2),
                                        color: statusColor),
                                    child: Text(
                                      'PROCESSED',
                                      style: theme.textWhiteStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(state.data[index].body),
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
                                  'Reprocessed',
                                  style: theme.positiveStyle,
                                ),
                                onPressed: () {}),
                            FlatButton.icon(
                                icon:
                                    Icon(Icons.delete, color: Colors.redAccent),
                                label: Text('Delete', style: theme.textStyle),
                                onPressed: () {}),
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
              // return ListTile(
              //   title: Text(state.data[index].body));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Click',
        onPressed: () => bloc.dispatch(SMSFetchAllMessage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
