// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_combat_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnAssignCombatActionMessage
_$SessionEncounterTurnAssignCombatActionMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEncounterTurnAssignCombatActionMessage(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        actionUuid: json['action_uuid'] as String,
        combatAction: CombatAction.fromJson(
          json['combat_action'] as Map<String, dynamic>,
        ),
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnAssignCombatActionMessageToJson(
  SessionEncounterTurnAssignCombatActionMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
  'combat_action': instance.combatAction.toJson(),
};

SessionEncounterTurnUnassignCombatActionMessage
_$SessionEncounterTurnUnassignCombatActionMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEncounterTurnUnassignCombatActionMessage(
        source: json['source'] as String?,
        destination: json['destination'] as String,
        actionUuid: json['action_uuid'] as String,
      )
      ..hasResponse = json['has_response'] as bool
      ..waitResponseTimeout = (json['wait_response_timeout'] as num?)?.toInt()
      ..broadcastIncludesSelf = json['broadcast_includes_self'] as bool;

Map<String, dynamic> _$SessionEncounterTurnUnassignCombatActionMessageToJson(
  SessionEncounterTurnUnassignCombatActionMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
};
