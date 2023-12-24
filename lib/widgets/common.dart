import 'package:core/network/network.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screen_adaptation.dart';

/// 水波纹效果
/// 使用：
/// ```
/// InkBox(
///   color: Colors.white,
///   child: Container(
///   height: xdp(44),
///   // decoration不要设置颜色，用InkBox的颜色
///   decoration: ...
///   child: ...
///   onTap: () {},
/// )
/// ```
class InkBox extends StatelessWidget {

  final BorderRadius? borderRadius;
  final Color? color;
  final Gradient? gradient;
  final Widget? child;
  final Function()? onTap;

  InkBox({
    this.borderRadius,
    this.color,
    this.gradient,
    @required this.onTap,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // 必须指定裁剪类型，默认是不裁剪
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: Ink(

        // 对InkWell包裹的widget进行装饰，可以添加padding
        decoration: BoxDecoration(
          color: color == null ? Colors.white : color,
          borderRadius: borderRadius,
          gradient: gradient
        ),
        child: InkWell(
//          focusColor: Colors.grey,
//          splashColor: Colors.black12,
//          highlightColor: Colors.black38,
          child: child,
          onTap: onTap,
        ),
      ),
    );
  }
}

Widget pullToRefreshWidget({
  required RefreshController controller,
  Function()? refresh,
  @required Widget? child,
}) {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: false,
    controller: controller,
    onRefresh: refresh,
    header: WaterDropHeader(),
    child: child,
  );
}

/// Http网络状态Widget，成功、失败、加载中、数据为空，配合network.dart使用
Widget networkWidget({
  required NetworkStatus status,
  bool isEmpty = false,
  required Widget successWidget,
  Widget? emptyWidget,
  Widget? loadingWidget,
  Widget? errorWidget,
}) {
  switch (status) {
    case NetworkStatus.success:
      return isEmpty ? (emptyWidget ?? defaultEmptyWidget()) : successWidget;
    case NetworkStatus.failure:
      return errorWidget ?? defaultErrorWidget();
    case NetworkStatus.loading:
      return loadingWidget ?? defaultLoadingWidget();
  }
  return SizedBox();
}

Widget defaultLoadingWidget() {
  return Center(
      child: CircularProgressIndicator()
  );
}

Widget defaultEmptyWidget() {
  return Center(
    child: Text("暂无数据", style: TextStyle(fontSize: xdp(14), color: Color(0xFF989797)),),
  );
}

Widget defaultErrorWidget() {
  return Center(
    child: Text("加载失败", style: TextStyle(fontSize: xdp(14), color: Color(0xFF989797))),
  );
}

// showToast(String message) {
//   Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
// }

//final emptyWidget = Center(child: Text("暂无数据", style: TextStyle(fontSize: xdp(16), color: Colors.grey[500])));

