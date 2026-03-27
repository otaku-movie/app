class ReReleaseHistoryItem {
  final int? id;
  final String? startDate;
  final String? endDate;
  final int? status;
  final String? versionInfo;
  final String? displayNameOverride;
  final String? posterOverride;
  final int? timeOverride;

  ReReleaseHistoryItem({
    this.id,
    this.startDate,
    this.endDate,
    this.status,
    this.versionInfo,
    this.displayNameOverride,
    this.posterOverride,
    this.timeOverride,
  });

  factory ReReleaseHistoryItem.fromJson(Map<String, dynamic> json) {
    int? _toInt(dynamic v) => v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');
    return ReReleaseHistoryItem(
      id: _toInt(json['id']),
      startDate: json['startDate']?.toString(),
      endDate: json['endDate']?.toString(),
      status: _toInt(json['status']),
      versionInfo: json['versionInfo']?.toString(),
      displayNameOverride: json['displayNameOverride']?.toString(),
      posterOverride: json['posterOverride']?.toString(),
      timeOverride: _toInt(json['timeOverride']),
    );
  }
}

