// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initiative_extra_dice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectInitiativeExtraDice _$EntityEffectInitiativeExtraDiceFromJson(
  Map<String, dynamic> json,
) =>
    EntityEffectInitiativeExtraDice(
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
        frequency: json['frequency'] == null
            ? null
            : TickerEvent.fromJson(json['frequency'] as Map<String, dynamic>),
        activationDiceThrowRequest:
            json['activation_dice_throw_request'] == null
            ? null
            : DiceThrowRequest.fromJson(
                json['activation_dice_throw_request'] as Map<String, dynamic>,
              ),
        activationDiceThrowValidResults:
            (json['activation_dice_throw_valid_results'] as List<dynamic>?)
                ?.map((e) => $enumDecode(_$DiceThrowResultTypeEnumMap, e))
                .toList() ??
            const [DiceThrowResultType.success],
        activationDiceThrowValueTransformer:
            json['activation_dice_throw_value_transformer'] == null
            ? null
            : EntityEffectActivationDiceThrowValueTransformer.fromJson(
                json['activation_dice_throw_value_transformer']
                    as Map<String, dynamic>,
              ),
        postEffects: (json['post_effects'] as List<dynamic>?)
            ?.map((e) => EntityEffect.fromJson(e as Map<String, dynamic>))
            .toList(),
        removeOnUnapply: json['remove_on_unapply'] as bool? ?? false,
        statusMessageTitle: json['status_message_title'] as String?,
        statusMessageText: json['status_message_text'] as String?,
        elapsedDurationUnits: (json['elapsed_duration_units'] as num?)?.toInt(),
        active: json['active'] as bool? ?? false,
        count: (json['count'] as num).toInt(),
      )
      ..elapsedTriggerUnits = (json['elapsed_trigger_units'] as num).toInt()
      ..elapsedFrequencyUnits = (json['elapsed_frequency_units'] as num?)
          ?.toInt();

Map<String, dynamic> _$EntityEffectInitiativeExtraDiceToJson(
  EntityEffectInitiativeExtraDice instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'trigger': _$EntityEffectTriggerEnumMap[instance.trigger]!,
  'trigger_ticker_event': instance.triggerTickerEvent?.toJson(),
  'duration': instance.duration?.toJson(),
  'frequency': instance.frequency?.toJson(),
  'activation_dice_throw_request': instance.activationDiceThrowRequest
      ?.toJson(),
  'activation_dice_throw_valid_results': instance
      .activationDiceThrowValidResults
      .map((e) => _$DiceThrowResultTypeEnumMap[e]!)
      .toList(),
  'activation_dice_throw_value_transformer': instance
      .activationDiceThrowValueTransformer
      ?.toJson(),
  'post_effects': instance.postEffects.map((e) => e.toJson()).toList(),
  'remove_on_unapply': instance.removeOnUnapply,
  'status_message_title': instance.statusMessageTitle,
  'status_message_text': instance.statusMessageText,
  'elapsed_trigger_units': instance.elapsedTriggerUnits,
  'elapsed_duration_units': instance.elapsedDurationUnits,
  'elapsed_frequency_units': instance.elapsedFrequencyUnits,
  'active': instance.active,
  'count': instance.count,
};

const _$EntityEffectTriggerEnumMap = {
  EntityEffectTrigger.diceThrow: 'diceThrow',
  EntityEffectTrigger.once: 'once',
  EntityEffectTrigger.permanent: 'permanent',
  EntityEffectTrigger.request: 'request',
  EntityEffectTrigger.tickerEvent: 'tickerEvent',
};

const _$DiceThrowResultTypeEnumMap = {
  DiceThrowResultType.none: 'none',
  DiceThrowResultType.criticalFail: 'criticalFail',
  DiceThrowResultType.fail: 'fail',
  DiceThrowResultType.success: 'success',
  DiceThrowResultType.criticalSuccess: 'criticalSuccess',
};
