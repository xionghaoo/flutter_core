import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;

import 'common.dart';

/// 签名画板
class SignPanel extends StatefulWidget {

  final SignController controller;
  final Color backgroundColor;
  final double height;

  SignPanel({
    Key key,
    @required this.controller,
    @required this.backgroundColor,
    this.height = 200
  }) : super(key: key);

  @override
  _SignPanelState createState() => _SignPanelState(controller) ;
}

class _SignPanelState extends State<SignPanel> {

  _SignPanelState(this.signController) {
    signController._setState(this);
  }

  final SignController signController;

  GlobalKey _repaintKey = GlobalKey();

  List<Offset> _points = [];

  Future<String> _saveSign() async {
    File f = await _createImageFile();
    String signPath = await _capturePng(f);
    return signPath;
  }

  /// 截图，并且返回图片的保存地址
  Future<String> _capturePng(File toFile) async {
    // 1. 获取 RenderRepaintBoundary
    RenderRepaintBoundary boundary = _repaintKey.currentContext.findRenderObject();
    // 2. 生成 Image
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    // 3. 生成 Uint8List
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    // 4. 本地存储Image
    toFile.writeAsBytes(pngBytes);

    return toFile.path;
  }

  /// 创建签名文件的路径
  Future<File> _createImageFile() async {
    Directory tempDir = await getTemporaryDirectory();
    int curT = DateTime.now().millisecondsSinceEpoch;
    String toFilePath = '${tempDir.path}/$curT.png';
    File toFile = File(toFilePath);
    bool exists = await toFile.exists();
    if (!exists) {
      await toFile.create(recursive: true);
    }
    return toFile;
  }

  _addPoints(DragUpdateDetails details) {
    RenderBox renderBox = _repaintKey.currentContext.findRenderObject();
    Offset localPos = renderBox.globalToLocal(details.globalPosition);
    double maxW = renderBox.size.width;
    double maxH = renderBox.size.height;
    // 校验范围
    if (localPos.dx <= 0 || localPos.dy <= 0) return;
    if (localPos.dx > maxW || localPos.dy > maxH) return;
    setState(() {
      _points = List.from(_points)..add(localPos);
    });
  }

  clear() {
    setState(() {
      _points.clear();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(SignPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
//    print("SignPanel build, ${mounted}");
    return RepaintBoundary(
      key: _repaintKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor
        ),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onPanUpdate: (details) => _addPoints(details),
              onPanEnd: (details) => _points.add(null),
            ),
            CustomPaint(
              painter: _SignPainter(_points, widget.backgroundColor),
            )
          ],
        ),
      ),
    );
  }
}

class _SignPainter extends CustomPainter {

  final List<Offset> points;
  Paint _paint = Paint()
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;

  final Color backgroundColor;

  _SignPainter(this.points, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制签名
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], _paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignPainter oldDelegate) {
    return oldDelegate.points != points || points.length == 0;
  }
}

class SignController {
  _SignPanelState _state;

  _setState(_SignPanelState state) {
    _state = state;
  }

  Future<String> saveSign() async {
    if (isEmpty()) {
      showToast("签名不能为空");
      return Future.value(null);
    }
    return _state._saveSign();
  }

  isEmpty() => _state._points.isEmpty;

  clear() async {
    _state.clear();
  }

}