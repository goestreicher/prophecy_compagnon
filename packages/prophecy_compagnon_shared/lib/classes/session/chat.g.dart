// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionChatMessage _$SessionChatMessageFromJson(Map<String, dynamic> json) =>
    SessionChatMessage(
      title: json['title'] as String?,
      text: json['text'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$SessionChatMessageToJson(SessionChatMessage instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
      'time': instance.time.toIso8601String(),
    };
