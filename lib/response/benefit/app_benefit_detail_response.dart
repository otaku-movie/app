import 'package:otaku_movie/response/benefit/app_benefit_item_response.dart';

/// App 端 - 特典阶段详情（与后端 BenefitDetailResponse 对应）
class AppBenefitDetailResponse {
  final int? id;
  final int? movieId;
  final String? movieName;
  final String? name;
  /// 总数（总库存）
  final int? quantity;
  /// 剩余数量（预估剩余库存）
  final int? remainingQuantity;
  final String? description;
  final List<String>? imageUrls;
  final int? dimensionType;
  final List<int>? specIds;
  final List<String>? specNames;
  final int? cinemaLimitType;
  final List<int>? cinemaIds;
  /// 限定影院名称列表（与 cinemaIds 一一对应）
  final List<String>? cinemaNames;
  final String? startDate;
  final String? endDate;
  final int? orderNum;
  /// 阶段状态：字典 benefitPhaseStatus 1=之前 2=进行中 3=已结束
  final int? status;
  final List<AppBenefitItemResponse>? items;

  AppBenefitDetailResponse({
    this.id,
    this.movieId,
    this.movieName,
    this.name,
    this.quantity,
    this.remainingQuantity,
    this.description,
    this.imageUrls,
    this.dimensionType,
    this.specIds,
    this.specNames,
    this.cinemaLimitType,
    this.cinemaIds,
    this.cinemaNames,
    this.startDate,
    this.endDate,
    this.orderNum,
    this.status,
    this.items,
  });

  factory AppBenefitDetailResponse.fromJson(Map<String, dynamic> json) {
    List<String>? imageUrls;
    if (json['imageUrls'] != null && json['imageUrls'] is List) {
      imageUrls = (json['imageUrls'] as List).map((e) => e.toString()).toList();
    }
    List<int>? specIds;
    if (json['specIds'] != null && json['specIds'] is List) {
      specIds = (json['specIds'] as List).map((e) => (e as num).toInt()).toList();
    }
    List<String>? specNames;
    if (json['specNames'] != null && json['specNames'] is List) {
      specNames = (json['specNames'] as List).map((e) => e.toString()).toList();
    }
    List<int>? cinemaIds;
    if (json['cinemaIds'] != null && json['cinemaIds'] is List) {
      cinemaIds = (json['cinemaIds'] as List).map((e) => (e as num).toInt()).toList();
    }
    List<String>? cinemaNames;
    if (json['cinemaNames'] != null && json['cinemaNames'] is List) {
      cinemaNames = (json['cinemaNames'] as List).map((e) => e.toString()).toList();
    }
    List<AppBenefitItemResponse>? items;
    if (json['items'] != null && json['items'] is List) {
      items = (json['items'] as List)
          .map((e) => AppBenefitItemResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return AppBenefitDetailResponse(
      id: (json['id'] as num?)?.toInt(),
      movieId: (json['movieId'] as num?)?.toInt(),
      movieName: json['movieName'] as String?,
      name: json['name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      remainingQuantity: (json['remainingQuantity'] as num?)?.toInt() ?? (json['remaining_quantity'] as num?)?.toInt() ?? (json['remaining'] as num?)?.toInt(),
      description: json['description'] as String?,
      imageUrls: imageUrls,
      dimensionType: (json['dimensionType'] as num?)?.toInt(),
      specIds: specIds,
      specNames: specNames,
      cinemaLimitType: (json['cinemaLimitType'] as num?)?.toInt(),
      cinemaIds: cinemaIds,
      cinemaNames: cinemaNames,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      orderNum: (json['orderNum'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      items: items,
    );
  }
}
