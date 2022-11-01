import '../models/app_config.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  String? baseUrl;
  String? ApiKey;

  HTTPService() {
    AppConfig config = getIt.get<AppConfig>();
    baseUrl = config.BASE_URL;
    ApiKey = config.API_KEY;
  }

  Future<Response?> get(String path, {Map<String, dynamic>?query}) async {
    try {
      String url = '$baseUrl$path';
      Map<String, dynamic> Query = {
        'api_key': ApiKey,
        'language': 'en-US',
      };
      if (query != null) {
        Query.addAll(query);
      }
      return await dio.get(url, queryParameters: Query);
    } on DioError catch (e) {
      print("Unable to perform GET request");
      print('DioError : $e');
    }
  }
}
