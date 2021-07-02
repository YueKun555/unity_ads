import 'package:dio/dio.dart';

class HttpClient {
  var _dio = Dio();

  Future<Response> get({
    String path,
    Map<String, dynamic> query,
    Map<String, dynamic> data,
    Options options,
  }) {
    options = options ?? Options();
    options.method = "GET";
    return _request(
      path: path,
      query: query,
      data: data,
      options: options,
    );
  }

  Future<Response> post({
    String path,
    Map<String, dynamic> query,
    Map<String, dynamic> data,
    Options options,
  }) {
    options = options ?? Options();
    options.method = "POST";
    return _request(
      path: path,
      query: query,
      data: data,
      options: options,
    );
  }

  Future<Response> _request({
    String path,
    Map<String, dynamic> query,
    Map<String, dynamic> data,
    Options options,
  }) {
    return _dio.request(
      path,
      queryParameters: query,
      data: data,
      options: options,
    );
  }
}
