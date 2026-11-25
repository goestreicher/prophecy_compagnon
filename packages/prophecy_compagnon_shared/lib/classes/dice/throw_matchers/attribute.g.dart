// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeDiceThrowMatcher _$AttributeDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => AttributeDiceThrowMatcher(
  attribute: $enumDecode(_$AttributeEnumMap, json['attribute']),
);

Map<String, dynamic> _$AttributeDiceThrowMatcherToJson(
  AttributeDiceThrowMatcher instance,
) => <String, dynamic>{'attribute': _$AttributeEnumMap[instance.attribute]!};

const _$AttributeEnumMap = {
  Attribute.physique: 'physique',
  Attribute.mental: 'mental',
  Attribute.manuel: 'manuel',
  Attribute.social: 'social',
};
