
import '../resources/DataProvider.dart';
import '../models/ItemModel.dart';

class Repository {
  final dataProvider = DataProvider();

  Future<ItemModel> fetchAllData() => dataProvider.fetchData();  
}