// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TickerEvent _$TickerEventFromJson(Map<String, dynamic> json) => TickerEvent(
  type: $enumDecode(_$TickerEventTypeEnumMap, json['type']),
  unit: $enumDecode(_$TickerEventUnitEnumMap, json['unit']),
  count: (json['count'] as num?)?.toInt() ?? 1,
  entityId: json['entity_id'] as String?,
);

Map<String, dynamic> _$TickerEventToJson(TickerEvent instance) =>
    <String, dynamic>{
      'type': _$TickerEventTypeEnumMap[instance.type]!,
      'unit': _$TickerEventUnitEnumMap[instance.unit]!,
      'count': instance.count,
      'entity_id': instance.entityId,
    };

const _$TickerEventTypeEnumMap = {
  TickerEventType.start: 'start',
  TickerEventType.end: 'end',
};

const _$TickerEventUnitEnumMap = {
  TickerEventUnit.action: 'action',
  TickerEventUnit.turn: 'turn',
  TickerEventUnit.combat: 'combat',
  TickerEventUnit.minute: 'minute',
  TickerEventUnit.hour: 'hour',
  TickerEventUnit.sleep: 'sleep',
  TickerEventUnit.day: 'day',
};

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
