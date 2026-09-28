// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectActivationDiceThrowValueTransformer
_$EntityEffectActivationDiceThrowValueTransformerFromJson(
  Map<String, dynamic> json,
) => EntityEffectActivationDiceThrowValueTransformer(
  base: (json['base'] as num?)?.toInt() ?? 0,
  nrMultiplier: (json['nr_multiplier'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$EntityEffectActivationDiceThrowValueTransformerToJson(
  EntityEffectActivationDiceThrowValueTransformer instance,
) => <String, dynamic>{
  'base': instance.base,
  'nr_multiplier': instance.nrMultiplier,
};
