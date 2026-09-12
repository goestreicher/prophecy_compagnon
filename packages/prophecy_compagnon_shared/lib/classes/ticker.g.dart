// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickerDuration _$TickerDurationFromJson(Map<String, dynamic> json) =>
    TickerDuration(
      count: (json['count'] as num).toInt(),
      unit: $enumDecode(_$TickerDurationUnitEnumMap, json['unit']),
    );

Map<String, dynamic> _$TickerDurationToJson(TickerDuration instance) =>
    <String, dynamic>{
      'count': instance.count,
      'unit': _$TickerDurationUnitEnumMap[instance.unit]!,
    };

const _$TickerDurationUnitEnumMap = {
  TickerDurationUnit.action: 'action',
  TickerDurationUnit.turn: 'turn',
  TickerDurationUnit.minute: 'minute',
  TickerDurationUnit.hour: 'hour',
  TickerDurationUnit.day: 'day',
};
