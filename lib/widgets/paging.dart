import 'package:flutter/material.dart';

typedef Widget PagingItemWidgetBuilder();
typedef void SuccessCallback(bool isEmpty);
typedef void SuccessListCallback<T>(List<T> data);
typedef void FailureCallback();

/// 分页辅助工具
/// 1、分页State，配合PagingModel一起使用
///
/// 子类需要调用的两个方法
/// pagingRefresh
/// pagingItemWidget
abstract class PagingState<W extends StatefulWidget> extends State<W> {
  
  final Function() loadData;
  
  PagingState({
    this.loadData  
  });
  
  bool _isLoading = false;
  bool _isEndOfList = false;

  PagingModel pagingModel();

  /// 刷新时重置底部加载视图
  void pagingRefresh() {
    _isEndOfList = false;
  }

  /// 加载下一页
  void _fetchMore() {
    if (!_isLoading) {
      _isLoading = true;
      final model = pagingModel();
      model.loadPagingData(
        isRefresh: false,
        /// 使用现有请求参数发起请求
        arguments: model.currentArguments,
        success: (isEmpty) {
          _isLoading = false;
          setState(() {
            _isEndOfList = isEmpty;
          });
        },
        failure: () {
          setState(() {
            _isEndOfList = true;
          });
        }
      );
    }
  }

  /// 构建分页列表子项
  pagingItemWidget<T>({
    @required int index,
    @required int listLength,
    @required PagingItemWidgetBuilder itemBuilder,
    /// loading more status
    Widget bottomLoadingWidget,
    /// no more status
    Widget bottomCompletedWidget
  }) {
    if (index < listLength) {
      return itemBuilder();
    } else if (index == listLength) {
      if (!_isEndOfList) {
        _fetchMore();
      } else {
        return bottomCompletedWidget ?? defaultCompletedWidget();
      }
      return bottomLoadingWidget ?? defaultLoading();
    }
  } 
  
}

/// 2、分页Model，配合PagingState一起使用
abstract class PagingModel<T> extends ChangeNotifier {
  /// 分页计数
  int nextPage = 1;
  /// 缓存请求参数，方便加载下一页时使用
  Map<String, dynamic> currentArguments = {};

  /// 分页数据加载方法
  /// arguments 可传递实际http请求的参数
  loadPagingData({bool isRefresh = true, Map<String, dynamic> arguments, Function(bool) success, Function failure}) {
    currentArguments = arguments;
    if (isRefresh) {
      nextPage = 1;
//      resource = Resource.loading();
      resetData();
    }
    pagingRequest(nextPage, arguments, (data) {
      if (isRefresh) {
//        resource = Resource.success(r.data.items);
        initialListData(data);
        nextPage ++;
      } else {
//        resource.data.addAll(r.data.items);
        afterListData(data);
        if (data.isNotEmpty) {
          nextPage ++;
        }
      }
      notifyListeners();
      success?.call(data.isEmpty);
    }, () {
      notifyListeners();
      failure?.call();
    });
  }

  /// 初始化分页列表数据
  /// 实现例子：resource = Resource.loading();
  resetData();

  /// 分页请求
  /// arguments: 请求参数传递工具
  /// success: 请求成功的回调，把请求成功的列表数据装进来
  /// failure：请求失败的回调，可用于处理resource的error状态，如: resource = Resource.error(); failure();
  pagingRequest(int page, Map<String, dynamic> arguments, SuccessListCallback success, FailureCallback failure);

  /// 第一次加载的列表数据
  /// 实现例子：resource = Resource.success(r.data.items);
  initialListData(List<T> items);

  /// 第二页开始加载的列表数据
  /// 实现例子：resource.data.addAll(r.data.items);
  afterListData(List<T> items);
}

Widget defaultCompletedWidget() {
  return Align(
    child: SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text("我是有底线的 ~", style: TextStyle(fontSize: 13, color: Color(0xFF999999)),),
      ),
    ),
  );
}

Widget defaultLoading() {
  return Align(
    child: SizedBox(
      height: 40,
      width: 40,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}