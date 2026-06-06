import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:dio/dio.dart';

class LocationUtil {
  static Future<Position?> getCurrentPosition({LocationAccuracy accuracy = LocationAccuracy.high}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
    } catch (_) {
      return null;
    }
  }

  /// 取系统缓存的最后一次定位（不主动激活 GPS / 不弹权限）。
  /// 几乎是立即返回的——用于「先把缓存位置填到请求里，
  /// 避免首屏先无定位拉一次、定位回来再拉一次」的场景。
  /// 没有缓存或没有权限时返回 null。
  static Future<Position?> getLastKnownPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  static Future<Placemark?> reverseGeocode(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) return null;
      return placemarks.first;
    } catch (_) {
      return null;
    }
  }

  /// 反向地理编码取「行政区划」结构化信息，用于和后端地区树做匹配。
  ///
  /// 与 [reverseGeocode] 的区别：
  ///   - 优先用 Nominatim 的结构化 `address` 字段（HTTP，稳定），
  ///     `placemarkFromCoordinates` 在不少机型/无 Google 服务时会失败返回 null，
  ///     导致「附近地区」匹配不到。
  ///   - 固定 `accept-language=ja`：后端地区树是日文地名，统一用日文反编码
  ///     才能稳定匹配（否则简中/英文地名与日文树跨字形对不上）。
  /// Nominatim 取不到时回退到本地 [reverseGeocode]。
  static Future<Placemark?> reverseGeocodeAdmin(Position position) async {
    try {
      final resp = await Dio(BaseOptions(headers: {
        'User-Agent': 'otaku_movie_app/1.0'
      })).get('https://nominatim.openstreetmap.org/reverse', queryParameters: {
        'lat': position.latitude,
        'lon': position.longitude,
        'format': 'jsonv2',
        'accept-language': 'ja',
        'addressdetails': 1,
      });
      if (resp.statusCode == 200 && resp.data is Map) {
        final addr = (resp.data as Map)['address'];
        if (addr is Map) {
          String? pick(List<String> keys) {
            for (final k in keys) {
              final v = addr[k];
              if (v is String && v.trim().isNotEmpty) return v.trim();
            }
            return null;
          }

          final admin = pick(['state', 'province', 'region']);
          final locality =
              pick(['city', 'county', 'town', 'municipality', 'village']);
          final sub =
              pick(['city_district', 'ward', 'suburb', 'neighbourhood']);
          if (admin != null || locality != null || sub != null) {
            return Placemark(
              administrativeArea: admin,
              locality: locality,
              subLocality: sub,
            );
          }
        }
      }
    } catch (_) {}
    return reverseGeocode(position);
  }

  static double? distanceBetweenMeters(Position from, double? toLat, double? toLng) {
    if (toLat == null || toLng == null) return null;
    try {
      return Geolocator.distanceBetween(from.latitude, from.longitude, toLat, toLng);
    } catch (_) {
      return null;
    }
  }

  static String formatDistance(num meters) {
    final m = meters.toDouble();
    if (m < 1000) return '${m.toStringAsFixed(0)}m';
    final km = m / 1000.0;
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)}km';
  }

  static String formatDistanceLocalized(BuildContext context, num meters) {
    final m = meters.toDouble();
    if (m < 1000) return '${m.toStringAsFixed(0)}${S.of(context).common_unit_meter}';
    final km = m / 1000.0;
    final unit = S.of(context).common_unit_kilometer;
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)}$unit';
  }

  static Future<String?> reverseGeocodeTextLocalized(BuildContext context, Position position) async {
    // Try Nominatim with accept-language to honor app locale
    try {
      final locale = Localizations.localeOf(context);
      final lang = locale.languageCode;
      final url = 'https://nominatim.openstreetmap.org/reverse';
      final resp = await Dio(BaseOptions(headers: {
        'User-Agent': 'otaku_movie_app/1.0'
      })).get(url, queryParameters: {
        'lat': position.latitude,
        'lon': position.longitude,
        'format': 'jsonv2',
        'accept-language': lang,
      });
      if (resp.statusCode == 200 && resp.data is Map) {
        final map = resp.data as Map;
        final text = map['display_name'] as String?;
        if (text != null && text.trim().isNotEmpty) return text.trim();
      }
    } catch (_) {}
    // Fallback to local Placemark composition
    try {
      final p = await reverseGeocode(position);
      if (p == null) return null;
      final parts = <String>[];
      void add(String? v) { if (v != null && v.trim().isNotEmpty) parts.add(v.trim()); }
      add(p.country);
      add(p.administrativeArea);
      add(p.locality);
      add(p.subLocality);
      add(p.street);
      add(p.postalCode);
      if (parts.isEmpty) return null;
      return parts.join(' ');
    } catch (_) {
      return null;
    }
  }
}


