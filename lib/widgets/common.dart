import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screen_adaptation.dart';
import '../theme/colors.dart';

/// 水波纹效果
class InkBox extends StatelessWidget {

  final BorderRadius borderRadius;
  final Color color;
  final Widget child;
  final Function onTap;

  InkBox({
    this.borderRadius,
    this.color,
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
        ),
        child: InkWell(
          child: child,
          onTap: onTap,
        ),
      ),
    );
  }
}

class ConfirmLightButton extends StatelessWidget {

  final String title;
  final double height;
  final double width;
  final Function onTap;

  ConfirmLightButton({
    @required this.title,
    @required this.onTap,
    this.height = 44,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return InkBox(
      borderRadius: BorderRadius.circular(xdp(4)),
      color: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 0.5
            ),
            borderRadius: BorderRadius.circular(xdp(4))
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: xdp(15), fontWeight: FontWeight.bold)),
      ),
      onTap: onTap,
    );
  }
}

class ConfirmButton extends StatelessWidget {

  final String title;
  final double height;
  final double width;
  final Function onTap;
  final bool disable;

  ConfirmButton({
    @required this.title,
    @required this.onTap,
    this.height = 44,
    this.width,
    this.disable = false
  });

  @override
  Widget build(BuildContext context) {
    return InkBox(
      borderRadius: BorderRadius.circular(xdp(4)),
      color: disable ? Colors.grey : Theme.of(context).primaryColor,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: xdp(17)),),
      ),
      onTap: disable ? null : onTap,
    );
  }
}

class CancelButton extends StatelessWidget {

  final String title;
  final double height;
  final double width;
  final Function onTap;

  CancelButton({
    @required this.title,
    @required this.onTap,
    this.height = 44,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return InkBox(
      borderRadius: BorderRadius.circular(xdp(4)),
      color: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorInputHintConst,
            width: 0.5
          ),
          borderRadius: BorderRadius.circular(xdp(4))
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: colorInputHintConst, fontSize: xdp(17)),),
      ),
      onTap: onTap,
    );
  }
}

const dividerWidget = const Divider(height: 0.5, thickness: 0.5, color: colorDividerConst,);

Widget pullToRefreshWidget({
  @required RefreshController controller,
  @required Function refresh,
  @required Widget child,
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

showToast(String message) {
  Fluttertoast.showToast(msg: message);
}

final emptyWidget = Center(child: Text("暂无数据", style: TextStyle(fontSize: xdp(16), color: Colors.grey[500])));

