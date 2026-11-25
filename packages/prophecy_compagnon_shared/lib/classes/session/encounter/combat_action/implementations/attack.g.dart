// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatActionAttack _$CombatActionAttackFromJson(Map<String, dynamic> json) =>
    CombatActionAttack(
      entityId: json['entity_id'] as String,
      rank: (json['rank'] as num).toInt(),
      effects:
          (json['effects'] as List<dynamic>?)
              ?.map((e) => SessionMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SessionMessage>[],
    );

Map<String, dynamic> _$CombatActionAttackToJson(CombatActionAttack instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'rank': instance.rank,
      'effects': instance.effects.map((e) => e.toJson()).toList(),
    };
