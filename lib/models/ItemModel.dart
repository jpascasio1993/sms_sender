class ItemModel {

  List<_ItemResult> _results = [];
  
  List<_ItemResult> get results => _results;
  
  ItemModel.fromJson(parsedJson){
    print(parsedJson);
    
    for(int i =0;i < parsedJson.length; i++) {
      //print('asd: ' + parsedJson[i]['title']);
     _results.add(_ItemResult(parsedJson[i]));
    }
    
  }
}

class _ItemResult {
    int _userId;
    int _id;
    String _title;
    String _body;

    _ItemResult(result){
      _userId = result['userId'];
      _id = result['id'];
      _title = result['title'];
      _body = result['body'];
    }

    int get userId => _userId;
    int get id => _id;
    String get title => _title;
    String get body => _body;

}