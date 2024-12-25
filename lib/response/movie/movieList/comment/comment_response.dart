import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'comment_response.g.dart';

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
    @JsonKey(name: "reply")
    final List<Reply>? reply;
    @JsonKey(name: "create_time")
    final String? createTime;
    @JsonKey(name: "update_time")
    final String? updateTime;

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
        this.reply,
        this.createTime,
        this.updateTime,
    });

    factory CommentResponse.fromJson(Map<String, dynamic> json) => _$CommentResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CommentResponseToJson(this);
}

@JsonSerializable()
class Reply {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "content")
    final String? content;
    @JsonKey(name: "comment_id")
    final int? commentId;
    @JsonKey(name: "comment_user_id")
    final int? commentUserId;
    @JsonKey(name: "comment_user_name")
    final String? commentUserName;
    @JsonKey(name: "comment_user_avatar")
    final String? commentUserAvatar;
    @JsonKey(name: "reply_user_id")
    final int? replyUserId;
    @JsonKey(name: "reply_user_name")
    final String? replyUserName;
    @JsonKey(name: "reply_user_avatar")
    final String? replyUserAvatar;
    @JsonKey(name: "movie_comment_id")
    final int? movieCommentId;
    @JsonKey(name: "like")
    final bool? like;
    @JsonKey(name: "unlike")
    final bool? unlike;
    @JsonKey(name: "like_count")
    final int? likeCount;
    @JsonKey(name: "unlike_count")
    final int? unlikeCount;
    @JsonKey(name: "parent_reply_id")
    final String? parentReplyId;
    @JsonKey(name: "create_time")
    final String? createTime;
    @JsonKey(name: "update_time")
    final String? updateTime;

    Reply({
        this.id,
        this.content,
        this.commentId,
        this.commentUserId,
        this.commentUserName,
        this.commentUserAvatar,
        this.replyUserId,
        this.replyUserName,
        this.replyUserAvatar,
        this.movieCommentId,
        this.like,
        this.unlike,
        this.likeCount,
        this.unlikeCount,
        this.parentReplyId,
        this.createTime,
        this.updateTime,
    });

    factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

    Map<String, dynamic> toJson() => _$ReplyToJson(this);
}
