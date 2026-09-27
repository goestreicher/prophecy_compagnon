// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceThrowEntityBaseMagicSkill _$DiceThrowEntityBaseMagicSkillFromJson(
  Map<String, dynamic> json,
) => DiceThrowEntityBaseMagicSkill(
  skill: $enumDecode(_$MagicSkillEnumMap, json['skill']),
  sphere: $enumDecode(_$MagicSphereEnumMap, json['sphere']),
);

Map<String, dynamic> _$DiceThrowEntityBaseMagicSkillToJson(
  DiceThrowEntityBaseMagicSkill instance,
) => <String, dynamic>{
  'skill': _$MagicSkillEnumMap[instance.skill]!,
  'sphere': _$MagicSphereEnumMap[instance.sphere]!,
};

const _$MagicSkillEnumMap = {
  MagicSkill.instinctive: 'instinctive',
  MagicSkill.invocatoire: 'invocatoire',
  MagicSkill.sorcellerie: 'sorcellerie',
};

const _$MagicSphereEnumMap = {
  MagicSphere.pierre: 'pierre',
  MagicSphere.feu: 'feu',
  MagicSphere.oceans: 'oceans',
  MagicSphere.metal: 'metal',
  MagicSphere.nature: 'nature',
  MagicSphere.reves: 'reves',
  MagicSphere.cite: 'cite',
  MagicSphere.vents: 'vents',
  MagicSphere.ombre: 'ombre',
};
