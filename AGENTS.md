# Android Debug Build

- Debug builds intentionally filter native ABIs to `arm64-v8a` in `android/app/build.gradle` to reduce APK size and speed up local `flutter run` install time.
- Release builds are not ABI-filtered by this debug setting and should keep the full publishing target behavior.
- If a non-arm64 Android device must be used for debugging, temporarily override the target platform with `flutter run --target-platform android-arm` or remove the debug `abiFilters` line.
