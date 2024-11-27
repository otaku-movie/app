// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

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
      createTime: json['create_time'] == null
          ? null
          : DateTime.parse(json['create_time'] as String),
      updateTime: json['update_time'] == null
          ? null
          : DateTime.parse(json['update_time'] as String),
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
      'create_time': instance.createTime?.toIso8601String(),
      'update_time': instance.updateTime?.toIso8601String(),
    };
