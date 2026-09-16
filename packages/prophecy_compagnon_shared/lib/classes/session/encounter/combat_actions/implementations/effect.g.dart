// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CombatActionEffect _$CombatActionEffectFromJson(Map<String, dynamic> json) =>
    CombatActionEffect(
      entityId: json['entity_id'] as String,
      rank: (json['rank'] as num).toInt(),
      effects: (json['effects'] as List<dynamic>)
          .map((e) => EntityEffect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CombatActionEffectToJson(CombatActionEffect instance) =>
    <String, dynamic>{
      'entity_id': instance.entityId,
      'rank': instance.rank,
      'effects': instance.effects.map((e) => e.toJson()).toList(),
    };
