import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';


@JsonSerializable()
class CommentResponse {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "content")
    final String? content;
    @JsonKey(name: "comment_user_id")
    final int? commentUserId;
    @JsonKey(name: "comment_user_name")
    final String? commentUserName;
    @JsonKey(name: "comment_user_avatar")
    final String? commentUserAvatar;
    @JsonKey(name: "movie_id")
    final int? movieId;
    @JsonKey(name: "like")
    final bool? like;
    @JsonKey(name: "unlike")
    final bool? unlike;
    @JsonKey(name: "like_count")
    final int? likeCount;
    @JsonKey(name: "unlike_count")
    final int? unlikeCount;
    @JsonKey(name: "reply_count")
    final int? replyCount;
    @JsonKey(name: "create_time")
    final DateTime? createTime;
    @JsonKey(name: "update_time")
    final DateTime? updateTime;

    CommentResponse({
        this.id,
        this.content,
        this.commentUserId,
        this.commentUserName,
        this.commentUserAvatar,
        this.movieId,
        this.like,
        this.unlike,
        this.likeCount,
        this.unlikeCount,
        this.replyCount,
        this.createTime,
        this.updateTime,
    });

    factory CommentResponse.fromJson(Map<String, dynamic> json) => _$CommentResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CommentResponseToJson(this);
}
