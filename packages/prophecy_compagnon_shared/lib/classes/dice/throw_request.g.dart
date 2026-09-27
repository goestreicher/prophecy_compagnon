// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'throw_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceThrowRequest _$DiceThrowRequestFromJson(Map<String, dynamic> json) =>
    DiceThrowRequest(
      type: $enumDecode(_$DiceThrowRequestTypeEnumMap, json['type']),
      context: $enumDecode(_$DiceThrowRequestContextEnumMap, json['context']),
      difficulty: (json['difficulty'] as num?)?.toInt(),
      base: DiceThrowEntityBase.fromJson(json['base'] as Map<String, dynamic>),
      allowTendencies: json['allow_tendencies'] as bool? ?? true,
    );

Map<String, dynamic> _$DiceThrowRequestToJson(DiceThrowRequest instance) =>
    <String, dynamic>{
      'type': _$DiceThrowRequestTypeEnumMap[instance.type]!,
      'context': _$DiceThrowRequestContextEnumMap[instance.context]!,
      'difficulty': instance.difficulty,
      'allow_tendencies': instance.allowTendencies,
      'base': instance.base.toJson(),
    };

const _$DiceThrowRequestTypeEnumMap = {
  DiceThrowRequestType.simple: 'simple',
  DiceThrowRequestType.opposition: 'opposition',
};

const _$DiceThrowRequestContextEnumMap = {
  DiceThrowRequestContext.none: 'none',
  DiceThrowRequestContext.discretion: 'discretion',
  DiceThrowRequestContext.perception: 'perception',
  DiceThrowRequestContext.reaction: 'reaction',
  DiceThrowRequestContext.resistance: 'resistance',
};
