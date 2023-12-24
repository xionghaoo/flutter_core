import 'package:flutter/material.dart';


/// 固定宽度tab切换组件
// class XTabView extends StatefulWidget {
//
//   final List<String> tabTitles;
//   final double width;
//   final Function(int) onTabSelected;
//   final XTabController controller;
//   final PageController pageController;
//
//   XTabView({
//     @required this.tabTitles,
//     @required this.controller,
//     @required this.pageController,
//     this.width,
//     this.onTabSelected
//   });
//
//   @override
//   _TabsViewState createState() => _TabsViewState(controller);
// }
//
// class _TabsViewState extends State<XTabView> with SingleTickerProviderStateMixin {
//
//   final XTabController tabController;
//
//   _TabsViewState(this.tabController) {
//     tabController.setTabState(this);
//   }
//
//   GlobalKey _sliderKey = GlobalKey();
//   List<GlobalKey> _tabKeys = [];
//
//   AnimationController _controller;
//   CurvedAnimation _curvedAnimation;
//   Animation _sliderAnimation;
//   double _extraSpaceWidth = 0;
//
//   final _sliderWidth = xdp(20);
//   final _sliderHeight = xdp(3);
//
//   double _tabWidth = 0;
//   double _totalWidth = 0;
//
//   bool _isSelectTab = false;
//   int _currentSelectIndex = 0;
//
//   _moveSlider(int index) {
//     setState(() {
//       _currentSelectIndex = index;
//     });
//     widget.onTabSelected(index);
//     _moveSliderToTab(_tabKeys[index], index);
//   }
//
//   List<Widget> _tabWidgets() {
//     List<Widget> tabs = [];
//     for (int i = 0; i < widget.tabTitles.length; i++) {
//       tabs.add(_tabWidget(i, widget.tabTitles[i], _tabKeys[i]));
//     }
//     return tabs;
//   }
//
//   _tabWidget(int index, String tabName, GlobalKey key) {
//     return Flexible(
//       flex: 1,
//       child: InkBox(
//         child: Container(
//           key: key,
//           alignment: Alignment.center,
//           child: _currentSelectIndex == index
//               ? Text(tabName, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: xdp(16), fontWeight: FontWeight.bold),)
//               : Text(tabName, style: TextStyle(color: Color(0xFF242424), fontSize: xdp(16)),),
//         ),
//         onTap: () {
//           /// 选择tab
//           _isSelectTab = true;
//           _moveSlider(index);
//           /// 移动page view，这时候不应该再移动tab view
//           widget.pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
//         },
//       ),
//     );
//   }
//
//   /// 重置滑块在当前tab的位置
//   void resetSlider(GlobalKey tabKey) {
//     _extraSpaceWidth = (_tabWidth - _sliderWidth) / 2;
//   }
//
//   Widget _sliderWidget() {
//     return Container(
//       key: _sliderKey,
//       width: _sliderWidth,
//       height: _sliderHeight,
//       decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//           borderRadius: BorderRadius.circular(xdp(4))
//       ),
//     );
//   }
//
//   void _moveSliderToTab(GlobalKey tabKey, int currentSliderBeforeTabsNum) {
//     if (_controller.isAnimating) {
//       _controller.stop();
//     }
//     RenderBox slider = _sliderKey.currentContext.findRenderObject();
//     Offset offset = slider.localToGlobal(Offset.zero);
//     double slideTotalTabsWidth = 0;
//     for (int i = 0; i <= currentSliderBeforeTabsNum; i++) {
//       slideTotalTabsWidth += _tabWidth;
//     }
//
//     /// 最后减掉的_extraSpaceWidth是因为slider的起点在dx = _extraSpaceWidth的位置
//     final sliderAnimEndDx = slideTotalTabsWidth - _extraSpaceWidth - slider.size.width - _extraSpaceWidth;
//     _sliderAnimation = Tween<double>(begin: offset.dx - _extraSpaceWidth, end: sliderAnimEndDx).animate(_curvedAnimation);
//     _controller.value = 0;
//     _controller.forward();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//         duration: const Duration(milliseconds: 500),
//         vsync: this
//     );
//
//     _curvedAnimation = CurvedAnimation(
//         parent: _controller,
//         curve: Curves.ease
//     )..addStatusListener((state) {
//     });
//
//     _totalWidth = widget.width == null ? MediaQuery.of(context).size.width : widget.width;
//     _sliderAnimation = Tween<double>(begin: 0, end: 1).animate(_curvedAnimation);
//
//     _tabWidth = _totalWidth / widget.tabTitles.length;
//     _extraSpaceWidth = (_tabWidth - _sliderWidth) / 2;
//
//     widget.tabTitles.forEach((tab) {
//       _tabKeys.add(GlobalKey());
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: _totalWidth,
//       height: xdp(50),
//       decoration: BoxDecoration(
//         color: Colors.white
//       ),
//       child: Stack(
//         alignment: Alignment.bottomLeft,
//         children: <Widget>[
//           Row(
//             children: _tabWidgets(),
//           ),
//           AnimatedBuilder(
//             animation: _sliderAnimation,
//             builder: (context, child) {
//               return Positioned(
//                 left: _extraSpaceWidth + _sliderAnimation.value,
//                 child: _sliderWidget(),
//               );
//             },
//             child: Positioned(
//               left: _extraSpaceWidth + _sliderAnimation.value,
//               child: _sliderWidget(),
//             )
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class XTabController {
//
//   /// 持有tabs view的state
//   _TabsViewState _state;
//
//   setTabState(_TabsViewState state) {
//     _state = state;
//   }
//
//   /// PageView 选择态
//   void moveTo(int index) {
//     if (!_state._isSelectTab) {
//       _state._moveSlider(index);
//     }
//
//     /// 移动到选中的tab时结束tab选择态
//     if (_state._currentSelectIndex == index) {
//       _state._isSelectTab = false;
//     }
//   }
// }