import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'comment_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CommentResponse {
    
    final int? id;
    
    final String? content;
    
    final int? commentUserId;
    
    final String? commentUserName;
    
    final String? commentUserAvatar;
    
    final int? movieId;
    
    bool? like;
    
    bool? dislike;
    
    int? likeCount;
    
    int? dislikeCount;
    
    final int? replyCount;
    
    final double? rate;
    
    final List<Reply>? reply;
    
    final String? createTime;
    
    final String? updateTime;

    CommentResponse({
        this.id,
        this.content,
        this.commentUserId,
        this.commentUserName,
        this.commentUserAvatar,
        this.movieId,
        this.rate,
        this.like = false,
        this.dislike = false,
        this.likeCount = 0,
        this.dislikeCount = 0,
        this.replyCount,
        this.reply,
        this.createTime,
        this.updateTime,
    });

    factory CommentResponse.fromJson(Map<String, dynamic> json) => _$CommentResponseFromJson(json);

    Map<String, dynamic> toJson() => _$CommentResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Reply {
    
    final int? id;
    
    final String? content;
    
    final int? commentId;
    
    final int? commentUserId;
    
    final String? commentUserName;
    
    final String? commentUserAvatar;
    
    final int? replyUserId;
    
    final String? replyUserName;
    
    final String? replyUserAvatar;
    
    final int? movieCommentId;
    
    final bool? like;
    
    final bool? dislike;
    
    final int? likeCount;
    
    final int? dislikeCount;
    
    final String? parentReplyId;
    
    final String? createTime;
    
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
        this.like = false,
        this.dislike = false,
        this.likeCount = 0,
        this.dislikeCount = 0,
        this.parentReplyId,
        this.createTime,
        this.updateTime,
    });

    factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);

    Map<String, dynamic> toJson() => _$ReplyToJson(this);
}
