
import 'package:dio/dio.dart';

enum NetworkStatus {
  loading, success, failure
}

class Resource<T> {
  final NetworkStatus status;
  final T data;
  final String message;

  Resource(this.status, this.data, this.message);

  factory Resource.success(T data) => Resource(NetworkStatus.success, data, null);

  factory Resource.loading({T data}) => Resource(NetworkStatus.loading, data, null);

  factory Resource.error({String error}) => Resource(NetworkStatus.failure, null, error);

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
    return Resource.success(response.body);
  } else {
    return Resource.error(error: response.error);
  }
}
