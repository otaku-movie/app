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

  static Future<Placemark?> reverseGeocode(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) return null;
      return placemarks.first;
    } catch (_) {
      return null;
    }
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


