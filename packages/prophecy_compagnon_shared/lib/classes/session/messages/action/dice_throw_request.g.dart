// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_throw_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionActionDiceThrowRequestMessage
_$SessionActionDiceThrowRequestMessageFromJson(Map<String, dynamic> json) =>
    SessionActionDiceThrowRequestMessage(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        entityId: json['entity_id'] as String,
        request: DiceThrowRequest.fromJson(
          json['request'] as Map<String, dynamic>,
        ),
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionActionDiceThrowRequestMessageToJson(
  SessionActionDiceThrowRequestMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'request': instance.request.toJson(),
};
