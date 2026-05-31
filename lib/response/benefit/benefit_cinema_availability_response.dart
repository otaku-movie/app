/// App GET /app/benefit/{benefitId}/cinemas 单条影院
class BenefitCinemaAvailabilityItem {
  final int? cinemaId;
  final String? cinemaName;
  final String? brandName;
  final String? fullAddress;
  final int? regionId;
  final int? prefectureId;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final int? quota;
  final int? remaining;
  final int? stockStatus;
  final int? feedbackCount;
  final int? feedbackWindowHours;
  /// 当前登录用户是否已反馈（未登录为 false）；与后端 Redis/DB 一致
  final bool currentUserFeedbackSubmitted;
  final int? showTimeCount;
  final String? nearestShowTime;

  BenefitCinemaAvailabilityItem({
    this.cinemaId,
    this.cinemaName,
    this.brandName,
    this.fullAddress,
    this.regionId,
    this.prefectureId,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.quota,
    this.remaining,
    this.stockStatus,
    this.feedbackCount,
    this.feedbackWindowHours,
    this.currentUserFeedbackSubmitted = false,
    this.showTimeCount,
    this.nearestShowTime,
  });

  factory BenefitCinemaAvailabilityItem.fromJson(Map<String, dynamic> json) {
    return BenefitCinemaAvailabilityItem(
      cinemaId: (json['cinemaId'] as num?)?.toInt(),
      cinemaName: json['cinemaName'] as String?,
      brandName: json['brandName'] as String?,
      fullAddress: json['fullAddress'] as String?,
      regionId: (json['regionId'] as num?)?.toInt(),
      prefectureId: (json['prefectureId'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      quota: (json['quota'] as num?)?.toInt(),
      remaining: (json['remaining'] as num?)?.toInt(),
      stockStatus: (json['stockStatus'] as num?)?.toInt(),
      feedbackCount: (json['feedbackCount'] as num?)?.toInt(),
      feedbackWindowHours: (json['feedbackWindowHours'] as num?)?.toInt(),
      currentUserFeedbackSubmitted: json['currentUserFeedbackSubmitted'] == true,
      showTimeCount: (json['showTimeCount'] as num?)?.toInt(),
      nearestShowTime: json['nearestShowTime'] as String?,
    );
  }
}
