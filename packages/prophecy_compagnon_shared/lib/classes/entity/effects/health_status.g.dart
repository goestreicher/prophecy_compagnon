// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectHealthStatus _$EntityEffectHealthStatusFromJson(
  Map<String, dynamic> json,
) => EntityEffectHealthStatus(
  uuid: json['uuid'] as String?,
  name: json['name'] as String,
  trigger: $enumDecode(_$EntityEffectTriggerEnumMap, json['trigger']),
  triggerTickerEvent: json['trigger_ticker_event'] == null
      ? null
      : TickerEvent.fromJson(
          json['trigger_ticker_event'] as Map<String, dynamic>,
        ),
  duration: json['duration'] == null
      ? null
      : TickerEvent.fromJson(json['duration'] as Map<String, dynamic>),
  postEffects: (json['post_effects'] as List<dynamic>?)
      ?.map((e) => EntityEffect.fromJson(e as Map<String, dynamic>))
      .toList(),
  elapsedDurationUnits: (json['elapsed_duration_units'] as num?)?.toInt(),
  active: json['active'] as bool? ?? false,
  status: $enumDecode(_$EntityHealthStatusFlagEnumMap, json['status']),
);

Map<String, dynamic> _$EntityEffectHealthStatusToJson(
  EntityEffectHealthStatus instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'trigger': _$EntityEffectTriggerEnumMap[instance.trigger]!,
  'trigger_ticker_event': instance.triggerTickerEvent?.toJson(),
  'duration': instance.duration?.toJson(),
  'post_effects': instance.postEffects.map((e) => e.toJson()).toList(),
  'elapsed_duration_units': instance.elapsedDurationUnits,
  'active': instance.active,
  'status': _$EntityHealthStatusFlagEnumMap[instance.status]!,
};

const _$EntityEffectTriggerEnumMap = {
  EntityEffectTrigger.once: 'once',
  EntityEffectTrigger.permanent: 'permanent',
  EntityEffectTrigger.request: 'request',
  EntityEffectTrigger.tickerEvent: 'tickerEvent',
};

const _$EntityHealthStatusFlagEnumMap = {
  EntityHealthStatusFlag.none: 'none',
  EntityHealthStatusFlag.injured: 'injured',
  EntityHealthStatusFlag.dead: 'dead',
  EntityHealthStatusFlag.stunned: 'stunned',
  EntityHealthStatusFlag.unconscious: 'unconscious',
};
