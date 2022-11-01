import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/http_service.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  HTTPService? http;

  MovieService() {
    http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({int? page}) async {
    Response? response = await http!.get('/movie/popular', query: {
      'page': page,
    });
    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception("Couldn't Load Popular Movies");
    }
  }

  Future<List<Movie>> getUpcomingMovies({int? page}) async {
    Response? response = await http!.get('/movie/upcoming', query: {
      'page': page,
    });
    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception("Couldn't Load Upcoming Movies");
    }
  }

  Future<List<Movie>> searchMovies(String searchTerm,{int? page}) async {
    Response? response = await http!.get('/search/movie', query: {
      'query': searchTerm,
      'page': page,
    });
    if (response!.statusCode == 200) {
      Map data = response.data;
      List<Movie> movies = data['results'].map<Movie>((movieData) {
        return Movie.fromJson(movieData);
      }).toList();
      return movies;
    } else {
      throw Exception("Couldn't Perform The Movie Search");
    }
  }

  
}
