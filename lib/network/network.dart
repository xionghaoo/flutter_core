
import 'package:dio/dio.dart';

enum NetworkStatus {
  loading, success, failure
}

class Resource<T> {
  final NetworkStatus status;
  final T? data;
  final String? message;

  Resource(this.status, this.data, this.message);

  factory Resource.success(T data) => Resource(NetworkStatus.success, data, null);

  factory Resource.loading({T? data}) => Resource(NetworkStatus.loading, data, null);

  factory Resource.error({String? error}) => Resource(NetworkStatus.failure, null, error);

}

/// 对http状态码进行转化封装
class ApiResponse<T> {
  int code = -1;
  T? body;
  String? error;

  final Response response;

  ApiResponse({required this.response, required T? data}) {
    code = response.statusCode ?? -1;
    if (code == 200) {
      body = data;
      error = null;
    } else if(code >= 500) {
      body = null;
      error = "服务器访问错误";
    } else {
      body = null;
      error = response.statusMessage;
    }
  }

  isSuccessful() => code == 200;
}
