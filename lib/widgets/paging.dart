import 'package:flutter/material.dart';

/// Provider 分页器
///
/// 用法：
/// 1、继承PagingState，实现pagingModel方法
/// class _DemoPageState extends PagingState<DemoPage> {
///
///   /// a. 实现pagingModel方法，返回PagingModel对象
///   @override
///   PagingModel pagingModel() => DemoModel.instance(context);
///
///   @override
///   void initState() {
///     super.initState();
///     /// b. 调用PagingState.loadPagingData()方法加载分页数据
///     loadPagingData();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Column(
///         children: [
///           ...
///           Expanded(
///             child: Selector<DemoModel, Resource<List<Item>>>(
///               selector: (_, model) => model.resource,
///               shouldRebuild: (before, next) => true,
///               builder: (_, res, __) {
///                 return res.data != null
///                     /// c. 使用PagingState.pagingListView显示分页列表
///                     ? pagingListView<Item>(
///                         totalSize: res.data!.length,
///                         itemBuilder: (index) => _itemWidget(res.data![index]),
///                     )
///                     : const Center(child: Text("空状态"));
///               }
///             ),
///           ),
///         ],
///       ),
///     );
///   }
/// }
///
/// 2、继承PagingModel，重写对应的方法
/// class DemoModel extends PagingModel<Item> {
///
///   Resource<List<Item>> resource = Resource.loading();
///
///   static DemoModel instance(BuildContext context) {
///     return Provider.of<DemoModel>(context, listen: false);
///   }
///
///   @override
///   Future<List<Item>> pagingRequest(int page, Map<String, dynamic>? arguments) async {
///     /// 模拟异步分页加载
///     await Future.delayed(const Duration(milliseconds: 200));
///     print("current page = $currentPage");
///     if (currentPage >= 10) {
///       return [];
///     } else {
///       return [
///         Item(name: "item0"),
///         Item(name: "item1"),
///         Item(name: "item2"),
///         Item(name: "item3"),
///         Item(name: "item4"),
///       ];
///     }
///   }
///
///   @override
///   requestResult(int page, List<Item> items) {
///     /// 保存每页数据
///     if (page == 1) {
///       resource = Resource.success(items);
///     } else {
///       resource.data?.addAll(items);
///     }
///   }
///
///   @override
///   resetData() {
///     /// 初始化分页数据状态
///     resource = Resource.loading();
///   }
/// }

typedef PagingItemWidgetBuilder = Widget Function(int);

abstract class PagingState<W extends StatefulWidget> extends State<W> {

  bool? _pagingFinished = false;

  /// 加载更多
  _fetchMore() {
    final model = pagingModel();
    model._page += 1;
    model._loadPagingData(
      arguments: model.arguments,
      success: (isEmpty) {
        setState(() {
          _pagingFinished = isEmpty;
        });
      },
      failure: () {
        setState(() {
          _pagingFinished = null;
        });
      }
    );
  }

  /// 分页器初始化加载，从第一页开始
  loadPagingData({Map<String, dynamic>? arguments}) {
    _pagingFinished = false;
    final model = pagingModel();
    model._loadPagingData(
      isRefresh: true,
      arguments: arguments,
      success: (isEmpty) {
        setState(() {
          _pagingFinished = isEmpty;
        });
      },
      failure: () {
        /// 为空表示当前页加载失败，结束分页
        setState(() {
          _pagingFinished = null;
        });
      }
    );
  }

  PagingModel pagingModel();

  /// 分页列表视图
  Widget pagingListView<T>({
    /// 列表总长度
    required int totalSize,
    /// 列表子项构建器
    required PagingItemWidgetBuilder itemBuilder,
    /// 底部加载更多视图
    Widget? loadingWidget,
    /// 底部加载完成视图
    Widget? completedWidget,
    /// 底部加载错误视图
    Widget? errorWidget
  }) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: totalSize + 1,
        itemBuilder: (context, index) {
          if (index < totalSize) {
            return itemBuilder(index);
          } else {
            /// build列表最后一项时加载下一页，如果到底，显示完成
            final isCompleted = _pagingFinished;
            if (isCompleted == false) {
              /// 加载下一页
              _fetchMore();
            }
            return isCompleted == null
                /// 加载错误的状态
                ? errorWidget ?? defaultErrorWidget()
                : isCompleted
                /// 加载中的状态
                ? loadingWidget ?? defaultCompletedWidget()
                /// 加载完成的状态
                : completedWidget ?? defaultCompletedWidget();
          }
        }
    );
  }

}

abstract class PagingModel<T> extends ChangeNotifier {
  int _page = 1;
  Map<String, dynamic>? arguments;

  int get currentPage => _page;

  _loadPagingData({bool? isRefresh, Map<String, dynamic>? arguments, Function(bool)? success, Function? failure}) {
    if (isRefresh == true) {
      _page = 1;
      resetData();
    }
    pagingRequest(_page, arguments).then((data) {
      requestResult(_page, data);
      // _page ++;
      notifyListeners();
      success?.call(data.isEmpty);
    }).catchError((e) {
      failure?.call();
    });
  }

  /// 分页请求
  /// arguments: 请求参数，用于从PagingState.loadPagingData里面传递参数到实际的请求中
  /// success: 请求成功的回调，返回当前请求的列表数据，为空时判定为分页结束
  /// failure：请求失败的回调
  Future<List<T>> pagingRequest(int page, Map<String, dynamic>? arguments);

  /// 请求结果
  /// page: 当前页数
  /// items: 当前页加载成功的结果集
  requestResult(int page, List<T> items);

  /// 初始化分页列表数据
  /// 实现例子：resource = Resource.loading();
  resetData();
}

Widget defaultCompletedWidget() {
  return const Align(
    child: SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text("我是有底线的 ~", style: TextStyle(fontSize: 13, color: Color(0xFF999999)),),
      ),
    ),
  );
}

Widget defaultLoadingWidget() {
  return const Align(
    child: SizedBox(
      height: 40,
      width: 40,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

Widget defaultErrorWidget() {
  return const Align(
    child: SizedBox(
      height: 40,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text("加载失败", style: TextStyle(fontSize: 13, color: Color(0xFF999999)),),
      ),
    ),
  );
}