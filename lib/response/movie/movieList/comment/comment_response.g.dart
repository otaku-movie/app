// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) =>
    CommentResponse(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      commentUserId: (json['comment_user_id'] as num?)?.toInt(),
      commentUserName: json['comment_user_name'] as String?,
      commentUserAvatar: json['comment_user_avatar'] as String?,
      movieId: (json['movie_id'] as num?)?.toInt(),
      like: json['like'] as bool?,
      unlike: json['unlike'] as bool?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      unlikeCount: (json['unlike_count'] as num?)?.toInt(),
      replyCount: (json['reply_count'] as num?)?.toInt(),
      reply: (json['reply'] as List<dynamic>?)
          ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
      createTime: json['create_time'] as String?,
      updateTime: json['update_time'] as String?,
    );

Map<String, dynamic> _$CommentResponseToJson(CommentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'comment_user_id': instance.commentUserId,
      'comment_user_name': instance.commentUserName,
      'comment_user_avatar': instance.commentUserAvatar,
      'movie_id': instance.movieId,
      'like': instance.like,
      'unlike': instance.unlike,
      'like_count': instance.likeCount,
      'unlike_count': instance.unlikeCount,
      'reply_count': instance.replyCount,
      'reply': instance.reply?.map((e) => e.toJson()).toList(),
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      id: (json['id'] as num?)?.toInt(),
      content: json['content'] as String?,
      commentId: (json['comment_id'] as num?)?.toInt(),
      commentUserId: (json['comment_user_id'] as num?)?.toInt(),
      commentUserName: json['comment_user_name'] as String?,
      commentUserAvatar: json['comment_user_avatar'] as String?,
      replyUserId: (json['reply_user_id'] as num?)?.toInt(),
      replyUserName: json['reply_user_name'] as String?,
      replyUserAvatar: json['reply_user_avatar'] as String?,
      movieCommentId: (json['movie_comment_id'] as num?)?.toInt(),
      like: json['like'] as bool?,
      unlike: json['unlike'] as bool?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      unlikeCount: (json['unlike_count'] as num?)?.toInt(),
      parentReplyId: json['parent_reply_id'] as String?,
      createTime: json['create_time'] as String?,
      updateTime: json['update_time'] as String?,
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'comment_id': instance.commentId,
      'comment_user_id': instance.commentUserId,
      'comment_user_name': instance.commentUserName,
      'comment_user_avatar': instance.commentUserAvatar,
      'reply_user_id': instance.replyUserId,
      'reply_user_name': instance.replyUserName,
      'reply_user_avatar': instance.replyUserAvatar,
      'movie_comment_id': instance.movieCommentId,
      'like': instance.like,
      'unlike': instance.unlike,
      'like_count': instance.likeCount,
      'unlike_count': instance.unlikeCount,
      'parent_reply_id': instance.parentReplyId,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };
