// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_movement_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionMapGetMovementPath _$SessionMapGetMovementPathFromJson(
  Map<String, dynamic> json,
) =>
    SessionMapGetMovementPath(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        waitResponseTimeout: (json['wait_response_timeout'] as num?)?.toInt(),
        entityId: json['entity_id'] as String,
        distanceMultiplier:
            (json['distance_multiplier'] as num?)?.toDouble() ?? 1.0,
      )
      ..hasResponse = json['has_response'] as bool
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionMapGetMovementPathToJson(
  SessionMapGetMovementPath instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'distance_multiplier': instance.distanceMultiplier,
};

SessionMapCancelGetMovementPath _$SessionMapCancelGetMovementPathFromJson(
  Map<String, dynamic> json,
) =>
    SessionMapCancelGetMovementPath(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        entityId: json['entity_id'] as String,
        cancelReason: json['cancel_reason'] as String?,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionMapCancelGetMovementPathToJson(
  SessionMapCancelGetMovementPath instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'cancel_reason': instance.cancelReason,
};
