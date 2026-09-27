// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delay_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnDelayActionMessage
_$SessionEncounterTurnDelayActionMessageFromJson(Map<String, dynamic> json) =>
    SessionEncounterTurnDelayActionMessage(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        actionUuid: json['action_uuid'] as String,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnDelayActionMessageToJson(
  SessionEncounterTurnDelayActionMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
};
