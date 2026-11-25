// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillFamilyDiceThrowMatcher _$SkillFamilyDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => SkillFamilyDiceThrowMatcher(
  family: $enumDecode(_$SkillFamilyEnumMap, json['family']),
);

Map<String, dynamic> _$SkillFamilyDiceThrowMatcherToJson(
  SkillFamilyDiceThrowMatcher instance,
) => <String, dynamic>{'family': _$SkillFamilyEnumMap[instance.family]!};

const _$SkillFamilyEnumMap = {
  SkillFamily.combat: 'combat',
  SkillFamily.mouvement: 'mouvement',
  SkillFamily.theorie: 'theorie',
  SkillFamily.pratique: 'pratique',
  SkillFamily.technique: 'technique',
  SkillFamily.manipulation: 'manipulation',
  SkillFamily.communication: 'communication',
  SkillFamily.influence: 'influence',
};
