class AppVersionCheckResponse {
  final String? latestVersion;
  final int? latestBuildNumber;
  final bool? forceUpdate;
  final bool? needUpdate;
  final String? downloadUrl;
  final String? releaseNote;
  final String? minSupportedVersion;
  /// 安装包大小展示文案，如 `~45.2 MB`（接口字段可为 packageSize / downloadSize / packageSizeDisplay）
  final String? packageSizeDisplay;

  AppVersionCheckResponse({
    this.latestVersion,
    this.latestBuildNumber,
    this.forceUpdate,
    this.needUpdate,
    this.downloadUrl,
    this.releaseNote,
    this.minSupportedVersion,
    this.packageSizeDisplay,
  });

  factory AppVersionCheckResponse.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => v is num ? v.toInt() : int.tryParse('${v ?? ''}');
    final sizeRaw = json['packageSizeDisplay'] ?? json['downloadSize'] ?? json['packageSize'];
    final sizeStr = sizeRaw?.toString().trim();
    return AppVersionCheckResponse(
      latestVersion: json['latestVersion']?.toString(),
      latestBuildNumber: toInt(json['latestBuildNumber']),
      forceUpdate: json['forceUpdate'] as bool?,
      needUpdate: json['needUpdate'] as bool?,
      downloadUrl: json['downloadUrl']?.toString(),
      releaseNote: json['releaseNote']?.toString(),
      minSupportedVersion: json['minSupportedVersion']?.toString(),
      packageSizeDisplay: (sizeStr == null || sizeStr.isEmpty) ? null : sizeStr,
    );
  }
}

