# otaku_movie

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 生成i18n 文件
```agsl
dart pub global run intl_utils:generate

# 国际化json生成arb
node lib/l10n/node/index.js
```

## json 序列化

```
dart run build_runner build
```
