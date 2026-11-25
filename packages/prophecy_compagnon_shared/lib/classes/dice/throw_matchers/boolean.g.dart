// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boolean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooleanOrDiceThrowMatcher _$BooleanOrDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => BooleanOrDiceThrowMatcher(
  children: (json['children'] as List<dynamic>)
      .map((e) => DiceThrowMatcher.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BooleanOrDiceThrowMatcherToJson(
  BooleanOrDiceThrowMatcher instance,
) => <String, dynamic>{
  'children': instance.children.map((e) => e.toJson()).toList(),
};

BooleanAndDiceThrowMatcher _$BooleanAndDiceThrowMatcherFromJson(
  Map<String, dynamic> json,
) => BooleanAndDiceThrowMatcher(
  children: (json['children'] as List<dynamic>)
      .map((e) => DiceThrowMatcher.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BooleanAndDiceThrowMatcherToJson(
  BooleanAndDiceThrowMatcher instance,
) => <String, dynamic>{
  'children': instance.children.map((e) => e.toJson()).toList(),
};
