
/// 实际屏幕缩放因子
/// 需要根据实际屏幕设置
double? scale;

/// 实际屏幕宽度：= px屏幕尺寸 / 缩放因子
/// 需要根据实际屏幕设置
double? screenWidth;

/// 设计稿的屏幕宽度
/// 2倍图，这是正常的屏幕尺寸，不加适配也可以正常显示，
/// 1倍图或者3倍图，如果不加适配无法正常显示
final double uiScreenWidth = 375.0;

final double uiScale = 2.0;

/// 适配尺寸计算
double xdp(double size) {
  if (scale == null || screenWidth == null) {
    throw Exception("请先初始化屏幕缩放因子和实际屏幕宽度");
  }
  return size * screenWidth! / uiScreenWidth;
}

