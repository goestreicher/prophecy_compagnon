// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_combat_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterTurnSetCombatActionMessage
_$SessionEncounterTurnSetCombatActionMessageFromJson(
  Map<String, dynamic> json,
) =>
    SessionEncounterTurnSetCombatActionMessage(
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

Map<String, dynamic> _$SessionEncounterTurnSetCombatActionMessageToJson(
  SessionEncounterTurnSetCombatActionMessage instance,
) => <String, dynamic>{
  'source': instance.source,
  'destination': instance.destination,
  'has_response': instance.hasResponse,
  'wait_response_timeout': instance.waitResponseTimeout,
  'broadcast_includes_self': instance.broadcastIncludesSelf,
  'action_uuid': instance.actionUuid,
  'combat_action': instance.combatAction.toJson(),
};
