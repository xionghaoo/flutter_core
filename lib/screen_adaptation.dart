
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
double xdp(double? size) {
  final width = screenWidth ?? 0.0;
  if (width <= 0 || size == null) {
    return size ?? 0;
  }
  return size * width / uiScreenWidth;
}

extension DpInt on int {
  double get dp => xdp(this.toDouble());
}

extension DpDouble on double {
  double get dp => xdp(this);
}
