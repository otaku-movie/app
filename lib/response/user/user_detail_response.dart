import 'package:json_annotation/json_annotation.dart';

part 'user_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserDetailResponse {
    
    final int? id;
    
    final String? name;
    
    final String? cover;
    
    final String? email;
    
    final String? createTime;
    
    final int? orderCount;
    
    final int? wantCount;

    /// 当前账号是否设置过本地密码。`false` 且 [oauthBindings] 只剩 1 条时，
    /// 解绑入口需要禁用 / 引导用户先去设置密码。
    final bool? hasPassword;

    /// 已绑定的第三方身份列表（最近登录时间倒序）。
    /// 用于「我的」页展示「通过 XX 登录」徽章，以及未来做账号管理/解绑。
    final List<OAuthBindingItem>? oauthBindings;

    UserDetailResponse({
        this.id,
        this.name,
        this.cover,
        this.email,
        this.createTime,
        this.orderCount,
        this.wantCount,
        this.hasPassword,
        this.oauthBindings,
    });

    factory UserDetailResponse.fromJson(Map<String, dynamic> json) => _$UserDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$UserDetailResponseToJson(this);
}

/// 第三方身份绑定项（脱敏后版本，不含 subject）。
@JsonSerializable(fieldRename: FieldRename.none)
class OAuthBindingItem {
    /// google / apple / x
    final String? provider;
    final String? name;
    final String? picture;
    final String? email;
    /// 形如 "2026-05-29 15:30:00"（GMT+9）。
    final String? lastLoginAt;
    final String? createTime;

    OAuthBindingItem({
        this.provider,
        this.name,
        this.picture,
        this.email,
        this.lastLoginAt,
        this.createTime,
    });

    factory OAuthBindingItem.fromJson(Map<String, dynamic> json) => _$OAuthBindingItemFromJson(json);

    Map<String, dynamic> toJson() => _$OAuthBindingItemToJson(this);
}
