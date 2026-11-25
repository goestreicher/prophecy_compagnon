// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbilityDiceThrowMatcher _$AbilityDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => AbilityDiceThrowMatcher(
  ability: $enumDecode(_$AbilityEnumMap, json['ability']),
);

Map<String, dynamic> _$AbilityDiceThrowMatcherToJson(
  AbilityDiceThrowMatcher instance,
) => <String, dynamic>{'ability': _$AbilityEnumMap[instance.ability]!};

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
