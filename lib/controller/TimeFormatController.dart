import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局时间显示偏好控制器：
/// - `use30HourFormat = false` => 标准 24 小时制（00:00 ~ 23:59）。
/// - `use30HourFormat = true`  => 30 小时制（日本影院常用：次日 00:00 ~ 05:59 显示为 24:00 ~ 29:59，
///   便于看出是同一个营业日的最后一场）。
///
/// 偏好通过 [SharedPreferences] 持久化，启动时尽早 `Get.put(...)` 并 `await init()`。
class TimeFormatController extends GetxController {
  static const String _prefsKey = 'time_format_use_30h';

  final RxBool use30HourFormat = false.obs;

  static TimeFormatController get instance => Get.find<TimeFormatController>();

  /// 从本地存储读取偏好；在 `runApp` 之前调用一次即可。
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      use30HourFormat.value = prefs.getBool(_prefsKey) ?? false;
    } catch (_) {
      use30HourFormat.value = false;
    }
  }

  /// 设置并持久化偏好。
  Future<void> setUse30HourFormat(bool value) async {
    use30HourFormat.value = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKey, value);
    } catch (_) {}
  }

  /// 切换偏好。
  Future<void> toggle() => setUse30HourFormat(!use30HourFormat.value);
}
