import 'package:flutter/material.dart';

typedef AuthCallback = Future<bool> Function();

/// 启动页面
/// 1、本地存在用户信息，跳转到登陆页面
/// 2、本地不存在用户信息，跳转到首页
/// 由于登陆信息是从native的sharedpreferences里面获取，因此是异步方式。
class SplashPage extends StatefulWidget {

  static final String path = "/";
  
  final Widget? loginPage;
  final Widget? homePage;
  final AuthCallback? hasAuthInfo;
  
  SplashPage({
    @required this.loginPage,
    @required this.homePage,
    @required this.hasAuthInfo
  });

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool? _hasUserInfo;

  Widget? _startPage() {
    return _hasUserInfo == null
        ? Container(color: Colors.white, alignment: Alignment.center,)
        : _hasUserInfo!
        ? widget.homePage
        : widget.loginPage;
  }

  @override
  void initState() {
    super.initState();

    widget.hasAuthInfo!().then((value) {
      setState(() {
        _hasUserInfo = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _startPage()!;
  }
}