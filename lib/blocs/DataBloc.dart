import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/ItemModel.dart';

class DataBloc {
  final _repository = Repository();
  final _dataFetcher = PublishSubject<ItemModel>();
  
  Observable<ItemModel> get allData => _dataFetcher.stream;

  fetchAllData() async {
    ItemModel itemModel = await _repository.fetchAllData();
    _dataFetcher.sink.add(itemModel);
  }

  dispose() {
    _dataFetcher.close();
  }
}

final databloc = DataBloc();