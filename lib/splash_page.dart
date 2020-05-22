import 'package:flutter/material.dart';

typedef AuthCallback = Future<bool> Function();

/// 启动页面
/// 1、本地存在用户信息，跳转到登陆页面
/// 2、本地不存在用户信息，跳转到首页
/// 由于登陆信息是从native的sharedpreferences里面获取，因此是异步方式。
/// 在决定启动哪个页面时用渐变动画遮盖掉由空页面切换到首页或登陆页的突兀变化，
/// 让App的启动看起来更加自然
class SplashPage extends StatefulWidget {

  static final String path = "/";
  
  final Widget loginPage;
  final Widget homePage;
  final AuthCallback hasAuthInfo;
  
  SplashPage({
    @required this.loginPage,
    @required this.homePage,
    @required this.hasAuthInfo
  });

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation<double> _fadeAnimation;

  bool _hasUserInfo;
  bool _showMarker = true;

//  Future<bool> _hasLoginInfo() async {
//    String token = await preferencesStorage.getStringData(PreferencesStorage.STRING_KEY_TOKEN_VALUE);
//    return token != null;
//  }

  Widget _startPage() {
    return _hasUserInfo == null
        ? SizedBox()
        : _hasUserInfo
        ? widget.homePage
        : widget.loginPage;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );

    _curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInCirc);

    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_curvedAnimation);

   widget.hasAuthInfo().then((value) {
      setState(() {
        _hasUserInfo = value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.forward();
        });
      });
    });

    _curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showMarker = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showMarker
        ? AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                _startPage(),
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                )
              ],
            );
          }
        )
        : _startPage();
  }
}