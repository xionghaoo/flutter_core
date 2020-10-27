import 'dart:async';

import 'package:core/screen_adaptation.dart';
import 'package:flutter/material.dart';

/// 搜索控件
/// 使用：
/// ```
///   Widget _searchWidget() {
///     return Container(
///       height: xdp(44),
///       color: Colors.white,
///       padding: EdgeInsets.symmetric(horizontal: xdp(22)),
///       child: Row(
///         children: <Widget>[
///           Expanded(
///             child: SearchTextField(
///               hintText: "客户手机号/收货人/微信昵称",
///               adaptSize: xdp,
///               onSearch: _onSearch,
///               focusNode: _focusNode,
///               controller: _searchController,
///             ),
///           ),
///           SizedBox(width: xdp(15),),
///           GestureDetector(
///             behavior: HitTestBehavior.opaque,
///             child: Padding(
///               padding: _focusNode.hasFocus ? EdgeInsets.symmetric(vertical: xdp(6)) : EdgeInsets.all(xdp(6)),
///               child: _focusNode.hasFocus
///                   ? Text("取消", style: TextStyle(color: color989797, fontSize: xdp(14)),)
///                   : Image.asset("images/ic_scan.png", width: xdp(19), height: xdp(19),),
///             ),
///             onTap: () {
///               if (_focusNode.hasFocus) {
///                 _searchController.text = "";
///                 _focusNode.unfocus();
///               } else {
///                 Navigator.pushNamed(context, QrCodeScanPage.path).then((value) {
///                   if (value != null) {
///                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScanResultPage(value)));
///                   }
///                 });
///               }
///             },
///           ),
///         ],
///       ),
///     );
///   }
/// ```
///

const _colorSearch = Color(0xFFF9F8F8);
const _colorSearchText = Color(0xFF989797);

typedef double AdaptSizeCallback(double size);

double _defaultCallback(double size) => size;

class SearchTextField extends StatefulWidget {

  final String hintText;
  final TextStyle hintStyle;
  final Function(String) onSearch;
  final AdaptSizeCallback adaptSize;
  final FocusNode focusNode;
  final TextEditingController controller;

  SearchTextField({
    this.hintText,
    this.hintStyle,
    this.onSearch,
    this.adaptSize = _defaultCallback,
    this.focusNode,
    this.controller
  });

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState(adaptSize, controller);
}

class _SearchTextFieldState extends State<SearchTextField> {

  final AdaptSizeCallback _xdp;
  _SearchTextFieldState(this._xdp, this._searchController) {
    if (_searchController == null) {
      _searchController = TextEditingController();
    }
  }

  TextEditingController _searchController;
  final _showClearIcon = ValueNotifier(false);
  Timer _searchTimer;

  /// 清空搜索内容
  _clear() {
    _searchController.text = "";
  }

  /// 取消本次搜索，即取消_updateSearch抛出的延时搜索动作
  _cancelSearch() {
    if (_searchTimer != null && _searchTimer.isActive) {
      _searchTimer.cancel();
      _searchTimer = null;
    }
  }

  /// 执行搜索，输入间隔350ms，即抛出一个延时搜索动作
  _updateSearch() {
    _cancelSearch();
    String txt = _searchController.text.trim();
    _showClearIcon.value = txt.isNotEmpty;
    _searchTimer = Timer(Duration(milliseconds: txt.isEmpty ? 0 : 350), () {
      widget.onSearch(txt);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _updateSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: _colorSearch,
            borderRadius: BorderRadius.circular(_xdp(16))
        ),
        height: _xdp(32),
        child: Row(
          children: <Widget>[
            SizedBox(width: _xdp(16),),
            Image.asset("images/ic_search.png", width: _xdp(14), height: _xdp(14),),
            SizedBox(width: _xdp(6),),
            Expanded(
              child: TextField(
                maxLines: 1,
                controller: _searchController,
                focusNode: widget.focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: widget.hintStyle ?? TextStyle(fontSize: xdp(14), color: _colorSearchText),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _showClearIcon,
              builder: (_, isShow, __) => isShow
                  ? GestureDetector(
                    child: Image.asset("images/ic_clear_search.png", width: _xdp(14), height: _xdp(14),),
                    onTap: _clear,
                  )
                  : SizedBox(),
            ),
            SizedBox(width: xdp(10),)
          ],
        )
    );
  }
}