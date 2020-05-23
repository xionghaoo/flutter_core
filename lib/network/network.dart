
import 'package:dio/dio.dart';

enum NetworkStatus {
  initial, loading, success, failure
}

class Resource<T> {
  final NetworkStatus status;
  final T data;
  final String message;

  Resource(this.status, this.data, this.message);
}

/// 对http状态码进行转化封装
class ApiResponse<T> {
  int code;
  T body;
  String error;

  final Response _response;

  ApiResponse(this._response, T data) {
    code = _response.statusCode;
    switch (code) {
      case 200:
        body = data;
        error = null;
        break;
      case 500:
        body = null;
        error = "服务器访问错误";
        break;
      default:
        body = null;
        error = _response.statusMessage;
    }
  }

  isSuccessful() => code == 200;
}

/// 处理http状态
Future<Resource<T>> networkStrategy<T>(ApiResponse response) async {
  if (response.isSuccessful()) {
    return Resource(NetworkStatus.success, response.body, null);
  } else {
    return Resource(NetworkStatus.failure, null, response.error);
  }
}
