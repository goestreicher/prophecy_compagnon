// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attack_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatActionAttackContext _$CombatActionAttackContextFromJson(
  Map<String, dynamic> json,
) => CombatActionAttackContext(
  cumulativeAttackMalus: (json['cumulative_attack_malus'] as num).toInt(),
  targetId: json['target_id'] as String,
  cumulativeDefenseMalus: (json['cumulative_defense_malus'] as num?)?.toInt(),
);

Map<String, dynamic> _$CombatActionAttackContextToJson(
  CombatActionAttackContext instance,
) => <String, dynamic>{
  'cumulative_attack_malus': instance.cumulativeAttackMalus,
  'target_id': instance.targetId,
  'cumulative_defense_malus': instance.cumulativeDefenseMalus,
};
