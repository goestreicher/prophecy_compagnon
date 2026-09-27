// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiative_extra_dice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectInitiativeExtraDice _$EntityEffectInitiativeExtraDiceFromJson(
  Map<String, dynamic> json,
) => EntityEffectInitiativeExtraDice(
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
  removeOnUnapply: json['remove_on_unapply'] as bool? ?? false,
  elapsedDurationUnits: (json['elapsed_duration_units'] as num?)?.toInt(),
  active: json['active'] as bool? ?? false,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$EntityEffectInitiativeExtraDiceToJson(
  EntityEffectInitiativeExtraDice instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'trigger': _$EntityEffectTriggerEnumMap[instance.trigger]!,
  'trigger_ticker_event': instance.triggerTickerEvent?.toJson(),
  'duration': instance.duration?.toJson(),
  'post_effects': instance.postEffects.map((e) => e.toJson()).toList(),
  'remove_on_unapply': instance.removeOnUnapply,
  'elapsed_duration_units': instance.elapsedDurationUnits,
  'active': instance.active,
  'count': instance.count,
};

const _$EntityEffectTriggerEnumMap = {
  EntityEffectTrigger.once: 'once',
  EntityEffectTrigger.permanent: 'permanent',
  EntityEffectTrigger.request: 'request',
  EntityEffectTrigger.tickerEvent: 'tickerEvent',
};
