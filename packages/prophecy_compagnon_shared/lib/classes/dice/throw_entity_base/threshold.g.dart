// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'threshold.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceThrowEntityBaseThresholdAbility
_$DiceThrowEntityBaseThresholdAbilityFromJson(Map<String, dynamic> json) =>
    DiceThrowEntityBaseThresholdAbility(
      comparison: $enumDecode(
        _$DiceThrowThresholdComparisonEnumMap,
        json['comparison'],
      ),
      ability: $enumDecode(_$AbilityEnumMap, json['ability']),
    );

Map<String, dynamic> _$DiceThrowEntityBaseThresholdAbilityToJson(
  DiceThrowEntityBaseThresholdAbility instance,
) => <String, dynamic>{
  'comparison': _$DiceThrowThresholdComparisonEnumMap[instance.comparison]!,
  'ability': _$AbilityEnumMap[instance.ability]!,
};

const _$DiceThrowThresholdComparisonEnumMap = {
  DiceThrowThresholdComparison.lowerThan: 'lowerThan',
  DiceThrowThresholdComparison.lowerThanOrEqual: 'lowerThanOrEqual',
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

DiceThrowEntityBaseThresholdLuck _$DiceThrowEntityBaseThresholdLuckFromJson(
  Map<String, dynamic> json,
) => DiceThrowEntityBaseThresholdLuck(
  comparison: $enumDecode(
    _$DiceThrowThresholdComparisonEnumMap,
    json['comparison'],
  ),
);

Map<String, dynamic> _$DiceThrowEntityBaseThresholdLuckToJson(
  DiceThrowEntityBaseThresholdLuck instance,
) => <String, dynamic>{
  'comparison': _$DiceThrowThresholdComparisonEnumMap[instance.comparison]!,
};
