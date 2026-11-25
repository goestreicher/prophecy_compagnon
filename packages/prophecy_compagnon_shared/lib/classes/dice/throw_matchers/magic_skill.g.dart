// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MagicSkillDiceThrowMatcher _$MagicSkillDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => MagicSkillDiceThrowMatcher(
  skill: $enumDecode(_$MagicSkillEnumMap, json['skill']),
);

Map<String, dynamic> _$MagicSkillDiceThrowMatcherToJson(
  MagicSkillDiceThrowMatcher instance,
) => <String, dynamic>{'skill': _$MagicSkillEnumMap[instance.skill]!};

const _$MagicSkillEnumMap = {
  MagicSkill.instinctive: 'instinctive',
  MagicSkill.invocatoire: 'invocatoire',
  MagicSkill.sorcellerie: 'sorcellerie',
};
