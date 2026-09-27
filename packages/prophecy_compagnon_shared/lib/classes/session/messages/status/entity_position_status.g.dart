// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_position_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEntityPositionStatusMessage _$SessionEntityPositionStatusMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEntityPositionStatusMessage(
        source: json['source'] as String?,
        broadcastIncludesSelf:
            json['broadcast_includes_self'] as bool? ?? false,
        entityId: json['entity_id'] as String,
        mapId: json['map_id'] as String,
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
      )
      ..destination = json['destination'] as String
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt();

Map<String, dynamic> _$SessionEntityPositionStatusMessageToJson(
  SessionEntityPositionStatusMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'map_id': instance.mapId,
  'x': instance.x,
  'y': instance.y,
};
