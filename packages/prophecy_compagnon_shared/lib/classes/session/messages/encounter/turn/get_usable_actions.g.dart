// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_usable_actions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnGetUsableActions
_$SessionEncounterTurnGetUsableActionsFromJson(Map<String, dynamic> json) =>
    SessionEncounterTurnGetUsableActions(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        entityId: json['entity_id'] as String,
        excludedActionUuids:
            (json['excluded_action_uuids'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const <String>[],
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnGetUsableActionsToJson(
  SessionEncounterTurnGetUsableActions instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'entity_id': instance.entityId,
  'excluded_action_uuids': instance.excludedActionUuids,
};
