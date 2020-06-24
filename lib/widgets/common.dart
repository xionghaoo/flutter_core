import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../screen_adaptation.dart';
import '../theme/colors.dart';

/// 水波纹效果
class InkBox extends StatelessWidget {

  final BorderRadius borderRadius;
  final Color color;
  final Gradient gradient;
  final Widget child;
  final Function onTap;

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

//const dividerWidget = const Divider(height: 0.5, thickness: 0.5, color: colorDividerConst,);

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

Widget pagingRefreshWidget({
  @required RefreshController controller,
  @required Function onRefresh,
  @required Function onLoading,
  @required Widget child,
}) {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: true,
    controller: controller,
    onRefresh: onRefresh,
    header: WaterDropHeader(),
    footer: CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (BuildContext context,LoadStatus mode){
        Widget body ;
        if(mode == LoadStatus.idle || mode == LoadStatus.loading || mode == LoadStatus.canLoading){
          body = CupertinoActivityIndicator();
        } else if(mode == LoadStatus.failed) {
          body = Text("加载失败");
        } else {
          body = Text("没有更多数据了~");
        }
        return Container(
          height: 55.0,
          child: Center(child:body),
        );
      },
    ),
    onLoading: onLoading,
    child: child,
  );
}

showToast(String message) {
  Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER);
}

//final emptyWidget = Center(child: Text("暂无数据", style: TextStyle(fontSize: xdp(16), color: Colors.grey[500])));

