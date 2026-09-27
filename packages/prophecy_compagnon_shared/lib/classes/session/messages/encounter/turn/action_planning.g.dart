// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_planning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnActionPlanningStart
_$SessionEncounterTurnActionPlanningStartFromJson(Map<String, dynamic> json) =>
    SessionEncounterTurnActionPlanningStart(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        actionUuid: json['action_uuid'] as String,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnActionPlanningStartToJson(
  SessionEncounterTurnActionPlanningStart instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
};

SessionEncounterTurnActionPlanningEnd
_$SessionEncounterTurnActionPlanningEndFromJson(Map<String, dynamic> json) =>
    SessionEncounterTurnActionPlanningEnd(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        actionUuid: json['action_uuid'] as String,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnActionPlanningEndToJson(
  SessionEncounterTurnActionPlanningEnd instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
};
