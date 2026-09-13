// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_effect_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectManager _$EntityEffectManagerFromJson(Map<String, dynamic> json) =>
    EntityEffectManager(
      entityEffects: (json['entity_effects'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EntityEffect.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

Map<String, dynamic> _$EntityEffectManagerToJson(
  EntityEffectManager instance,
) => <String, dynamic>{
  'entity_effects': instance.entityEffects.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
