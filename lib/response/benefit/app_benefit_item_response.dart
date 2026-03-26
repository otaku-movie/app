/// App 端 - 特典物料（与后端 BenefitItemResponse 对应）
class AppBenefitItemResponse {
  final int? id;
  final int? benefitId;
  final String? name;
  final String? imageUrl;
  final int? dimensionType;
  final int? specId;
  final String? specName;
  final int? orderNum;

  AppBenefitItemResponse({
    this.id,
    this.benefitId,
    this.name,
    this.imageUrl,
    this.dimensionType,
    this.specId,
    this.specName,
    this.orderNum,
  });

  factory AppBenefitItemResponse.fromJson(Map<String, dynamic> json) {
    return AppBenefitItemResponse(
      id: (json['id'] as num?)?.toInt(),
      benefitId: (json['benefitId'] as num?)?.toInt(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      dimensionType: (json['dimensionType'] as num?)?.toInt(),
      specId: (json['specId'] as num?)?.toInt(),
      specName: json['specName'] as String?,
      orderNum: (json['orderNum'] as num?)?.toInt(),
    );
  }
}
