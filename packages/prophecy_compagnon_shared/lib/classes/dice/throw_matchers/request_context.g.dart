// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_context.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThrowRequestContextDiceThrowMatcher
_$ThrowRequestContextDiceThrowMatcherFromJson(Map<String, dynamic> json) =>
    ThrowRequestContextDiceThrowMatcher(
      context: $enumDecode(_$DiceThrowRequestContextEnumMap, json['context']),
    );

Map<String, dynamic> _$ThrowRequestContextDiceThrowMatcherToJson(
  ThrowRequestContextDiceThrowMatcher instance,
) => <String, dynamic>{
  'context': _$DiceThrowRequestContextEnumMap[instance.context]!,
};

const _$DiceThrowRequestContextEnumMap = {
  DiceThrowRequestContext.none: 'none',
  DiceThrowRequestContext.attack: 'attack',
  DiceThrowRequestContext.defense: 'defense',
  DiceThrowRequestContext.discretion: 'discretion',
  DiceThrowRequestContext.luck: 'luck',
  DiceThrowRequestContext.perception: 'perception',
  DiceThrowRequestContext.reaction: 'reaction',
  DiceThrowRequestContext.resistance: 'resistance',
};
