// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionSetStateBoardPush _$SessionSetStateBoardPushFromJson(
  Map<String, dynamic> json,
) =>
    SessionSetStateBoardPush(
        item: SessionBoardItem.fromJson(json['item'] as Map<String, dynamic>),
        source: json['source'] as String?,
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionSetStateBoardPushToJson(
  SessionSetStateBoardPush instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'item': instance.item.toJson(),
};

SessionSetStateBoardSelect _$SessionSetStateBoardSelectFromJson(
  Map<String, dynamic> json,
) =>
    SessionSetStateBoardSelect(
        index: (json['index'] as num).toInt(),
        source: json['source'] as String?,
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionSetStateBoardSelectToJson(
  SessionSetStateBoardSelect instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'index': instance.index,
};

SessionSetStateBoardRemove _$SessionSetStateBoardRemoveFromJson(
  Map<String, dynamic> json,
) =>
    SessionSetStateBoardRemove(
        index: (json['index'] as num).toInt(),
        source: json['source'] as String?,
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionSetStateBoardRemoveToJson(
  SessionSetStateBoardRemove instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'index': instance.index,
};
