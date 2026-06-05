# App 图标源图

把品牌 logo 放到这里，文件名要与 `pubspec.yaml` 的 `flutter_launcher_icons` 配置一致：

| 文件 | 用途 | 要求 |
|------|------|------|
| `app_icon.png` | 主图标（iOS + Android 普通图标） | 1024×1024，方形，**无透明通道**（iOS 不允许透明），无圆角（系统自动裁切） |
| `app_icon_foreground.png` | Android 8.0+ 自适应图标前景 | 1024×1024，**透明背景**，主体居中并留约 25% 安全边距（外圈会被裁掉） |

放好图后执行：

```bash
flutter pub get
dart run flutter_launcher_icons
```

即可生成 Android（含 `mipmap-anydpi-v26` 自适应图标）与 iOS 全套尺寸，覆盖当前的 Flutter 默认蓝色图标。

> 当前目录下的 `app_icon.png` / `app_icon_foreground.png` 仅为占位说明，**上线前必须替换成真实 logo** 再重新生成。
