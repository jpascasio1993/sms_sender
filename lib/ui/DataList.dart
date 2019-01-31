import 'package:flutter/material.dart';
import '../blocs/DataBloc.dart';
import '../models/ItemModel.dart';
import '../ui/DataDetails.dart';

class DataList extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
   
    return DataListState();
  }

}

class DataListState extends State<DataList> {

  @override
  void initState() {
    super.initState();
    databloc.fetchAllData();
  }

  @override
  void dispose() {
    databloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Data'),
        centerTitle: true
      ),
      body: StreamBuilder(
        stream: databloc.allData,
        builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
            if(snapshot.hasData)
            {
              return buildList(snapshot);
            }
            else if(snapshot.hasError){
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.results.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
              enableFeedback: true,
              child: ListTile(
                title: Text( snapshot.data.results[index].title),
              ),
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>  DataDetails(title:  snapshot.data.results[index].title)))
            );
        
      }
    );
  }
}