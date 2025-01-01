// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) =>
    CommentResponse(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      commentUserId: (json['commentUserId'] as num?)?.toInt(),
      commentUserName: json['commentUserName'] as String?,
      commentUserAvatar: json['commentUserAvatar'] as String?,
      movieId: (json['movieId'] as num?)?.toInt(),
      rate: (json['rate'] as num?)?.toDouble(),
      like: json['like'] as bool? ?? false,
      dislike: json['dislike'] as bool? ?? false,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      dislikeCount: (json['dislikeCount'] as num?)?.toInt() ?? 0,
      replyCount: (json['replyCount'] as num?)?.toInt(),
      reply: (json['reply'] as List<dynamic>?)
          ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$CommentResponseToJson(CommentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'commentUserId': instance.commentUserId,
      'commentUserName': instance.commentUserName,
      'commentUserAvatar': instance.commentUserAvatar,
      'movieId': instance.movieId,
      'like': instance.like,
      'dislike': instance.dislike,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'replyCount': instance.replyCount,
      'rate': instance.rate,
      'reply': instance.reply?.map((e) => e.toJson()).toList(),
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      commentId: (json['commentId'] as num?)?.toInt(),
      commentUserId: (json['commentUserId'] as num?)?.toInt(),
      commentUserName: json['commentUserName'] as String?,
      commentUserAvatar: json['commentUserAvatar'] as String?,
      replyUserId: (json['replyUserId'] as num?)?.toInt(),
      replyUserName: json['replyUserName'] as String?,
      replyUserAvatar: json['replyUserAvatar'] as String?,
      movieCommentId: (json['movieCommentId'] as num?)?.toInt(),
      like: json['like'] as bool? ?? false,
      dislike: json['dislike'] as bool? ?? false,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      dislikeCount: (json['dislikeCount'] as num?)?.toInt() ?? 0,
      parentReplyId: json['parentReplyId'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'commentId': instance.commentId,
      'commentUserId': instance.commentUserId,
      'commentUserName': instance.commentUserName,
      'commentUserAvatar': instance.commentUserAvatar,
      'replyUserId': instance.replyUserId,
      'replyUserName': instance.replyUserName,
      'replyUserAvatar': instance.replyUserAvatar,
      'movieCommentId': instance.movieCommentId,
      'like': instance.like,
      'dislike': instance.dislike,
      'likeCount': instance.likeCount,
      'dislikeCount': instance.dislikeCount,
      'parentReplyId': instance.parentReplyId,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
