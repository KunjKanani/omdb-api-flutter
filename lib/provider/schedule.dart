import 'package:flutter/cupertino.dart';
import 'package:tradexa/model/movie.dart';

class Schedule with ChangeNotifier {
  List<Movie> _movieList = [];
  bool _hasMovies = false;
  bool _loading = false;
  bool _notFound = false;

  List<Movie> get movieList => _movieList;

  set movieList(List<Movie> value) {
    _movieList = value;
    notifyListeners();
  }

  bool get hasMovies => _hasMovies;

  set hasMovies(bool value) {
    _hasMovies = value;
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get notFound => _notFound;

  set notFound(bool value) {
    _notFound = value;
    notifyListeners();
  }
}