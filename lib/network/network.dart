
import 'package:dio/dio.dart';

abstract class BaseData {
  final int code;
  final String message;

  BaseData(this.code, this.message);
}

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

/// 处理业务状态码
Future<T> handleResponse<T>(Future<Resource<T>> future, Function(int) statusCall) {
  return Stream.fromFuture(future).map((r) {
    if (r.status == NetworkStatus.success) {
      if (r.data is BaseData) {
        final base = r.data as BaseData;
        statusCall(base.code);
        switch(base.code) {
          case 0:
            // 请求成功
            return r.data;
          case 200:
            // 登陆失效
            break;
          default:

        }
      } else {
        throw Exception("data must extend BaseData");
      }
    } else {
      // 显示错误信息
//      showToast(r.message);
    }
    return null;
  }).first;
}

test() {

}