// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceThrowEntityBaseAbility _$DiceThrowEntityBaseAbilityFromJson(
  Map<String, dynamic> json,
) => DiceThrowEntityBaseAbility(
  attribute: $enumDecode(_$AttributeEnumMap, json['attribute']),
  ability: $enumDecode(_$AbilityEnumMap, json['ability']),
);

Map<String, dynamic> _$DiceThrowEntityBaseAbilityToJson(
  DiceThrowEntityBaseAbility instance,
) => <String, dynamic>{
  'attribute': _$AttributeEnumMap[instance.attribute]!,
  'ability': _$AbilityEnumMap[instance.ability]!,
};

const _$AttributeEnumMap = {
  Attribute.physique: 'physique',
  Attribute.mental: 'mental',
  Attribute.manuel: 'manuel',
  Attribute.social: 'social',
};

const _$AbilityEnumMap = {
  Ability.force: 'force',
  Ability.intelligence: 'intelligence',
  Ability.coordination: 'coordination',
  Ability.presence: 'presence',
  Ability.resistance: 'resistance',
  Ability.volonte: 'volonte',
  Ability.perception: 'perception',
  Ability.empathie: 'empathie',
};
