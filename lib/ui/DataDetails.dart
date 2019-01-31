import 'package:flutter/material.dart';

class DataDetails extends StatefulWidget {
  final String title;
  DataDetails({
    this.title
  });
  
  @override
  State<StatefulWidget> createState() {
    return DataDetailsState(title: this.title);
  }
}

class DataDetailsState extends State<DataDetails>{

  final String title;

  DataDetailsState({
    this.title
  });

  @override
  void initState() {
    // TODO: implement initState
     print('initState');
    super.initState();
   
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print('didChangeDependencies');
    super.didChangeDependencies();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }

}