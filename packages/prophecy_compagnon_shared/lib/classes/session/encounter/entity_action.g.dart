// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEncounterEntityAction _$SessionEncounterEntityActionFromJson(
  Map<String, dynamic> json,
) =>
    SessionEncounterEntityAction(
        uuid: json['uuid'] as String?,
        entity: EntityBase.fromJson(json['entity'] as Map<String, dynamic>),
        initialRank: (json['initial_rank'] as num).toInt(),
        weakHand: json['weak_hand'] as bool? ?? false,
        combatAction: json['combat_action'] == null
            ? null
            : CombatAction.fromJson(
                json['combat_action'] as Map<String, dynamic>,
              ),
      )
      ..delayed = (json['delayed'] as num).toInt()
      ..stage = $enumDecode(
        _$SessionEncounterEntityActionStageEnumMap,
        json['stage'],
      );

Map<String, dynamic> _$SessionEncounterEntityActionToJson(
  SessionEncounterEntityAction instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'entity': instance.entity.toJson(),
  'initial_rank': instance.initialRank,
  'delayed': instance.delayed,
  'weak_hand': instance.weakHand,
  'stage': _$SessionEncounterEntityActionStageEnumMap[instance.stage]!,
  'combat_action': instance.combatAction?.toJson(),
};

const _$SessionEncounterEntityActionStageEnumMap = {
  SessionEncounterEntityActionStage.none: 'none',
  SessionEncounterEntityActionStage.assigned: 'assigned',
  SessionEncounterEntityActionStage.planned: 'planned',
  SessionEncounterEntityActionStage.approved: 'approved',
  SessionEncounterEntityActionStage.executed: 'executed',
};
