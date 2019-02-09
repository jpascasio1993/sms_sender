// class OutboxModel {
//   List<_ItemResult> _results = [];

//   List<_ItemResult> get results => _results;

//   OutboxModel.fromJson(parsedJson) {
//     print(parsedJson);

//     for (int i = 0; i < parsedJson.length; i++) {
//       //print('asd: ' + parsedJson[i]['title']);
//       _results.add(_ItemResult(parsedJson[i]));
//     }
//   }
// }

class OutboxModel {
  int _id;
  String _title;
  String _body;
  String _sendTo;
  String _date;

  OutboxModel(result) {
    _id = result['id'];
    _title = result['title'];
    _body = result['body'];
    _sendTo = result['sendTo'] != null ? result['sendTo'] : "+639162507727";
    _date = result['date'];
  }

  int get id => _id;
  String get title => _title;
  String get body => _body;
  String get sendTo => _sendTo;
  String get date => _date;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': title,
      'body': body,
      'sendTo': sendTo,
      'date': date
    };
  }
}
