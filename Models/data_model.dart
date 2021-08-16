import 'model.dart';
import 'package:shrijansrm264/Models/model.dart';

class Movie extends Model {
  static String table = 'movies';
  int id;
  String MovieName;
  String DirName;
  String PosterImg;

  Movie({
    this.id,
    this.MovieName,
    this.DirName,
    this.PosterImg,
  });

  static Movie fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map["id"],
      MovieName: map['MovieName'],
      DirName: map['DirName'],
      PosterImg: map['PosterImg'],
    );
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'MovieName': MovieName,
      'DirName': DirName,
      'PosterImg': PosterImg,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
