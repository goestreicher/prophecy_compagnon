// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionMapSelectTarget _$SessionMapSelectTargetFromJson(
  Map<String, dynamic> json,
) =>
    SessionMapSelectTarget(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        waitResponseTimeout: (json['wait_response_timeout'] as num?)?.toInt(),
        entityId: json['entity_id'] as String,
        distance: (json['distance'] as num).toDouble(),
      )
      ..hasResponse = json['has_response'] as bool
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionMapSelectTargetToJson(
  SessionMapSelectTarget instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'distance': instance.distance,
};

SessionMapCancelSelectTarget _$SessionMapCancelSelectTargetFromJson(
  Map<String, dynamic> json,
) =>
    SessionMapCancelSelectTarget(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        entityId: json['entity_id'] as String,
        cancelReason: json['cancel_reason'] as String?,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionMapCancelSelectTargetToJson(
  SessionMapCancelSelectTarget instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'cancel_reason': instance.cancelReason,
};
