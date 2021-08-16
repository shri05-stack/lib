import 'package:Shrijansrm264/Models/data_model.dart';
import 'package:Shrijansrm264/utils/db_helper.dart';

class DBService {
  Future<bool> addProduct(Movie model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.insert(Movie.table, model);

      isSaved = inserted == 1 ? true : false;
    }

    return isSaved;
  }

  Future<bool> updateProduct(Movie model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int updated = await DB.update(Movie.table, model);

      isSaved = updated == 1 ? true : false;
    }

    return isSaved;
  }

  Future<List<Movie>> getProducts() async {
    await DB.init();
    List<Map<String, dynamic>> products = await DB.query(Movie.table);

    return products.map((item) => Movie.fromMap(item)).toList();
  }


  Future<bool> deleteProduct(Movie model) async {
    await DB.init();
    bool isDeleted = false;
    if (model != null) {
      int deleted = await DB.delete(Movie.table, model);

      isDeleted = deleted == 1 ? true : false;
    }

    return isDeleted;
  }
}
