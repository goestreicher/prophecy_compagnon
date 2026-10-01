// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectAbilityModifier _$EntityEffectAbilityModifierFromJson(
  Map<String, dynamic> json,
) => EntityEffectAbilityModifier(
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
  activationDiceThrowRequest: json['activation_dice_throw_request'] == null
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
  elapsedDurationUnits: (json['elapsed_duration_units'] as num?)?.toInt(),
  active: json['active'] as bool? ?? false,
  ability: $enumDecode(_$AbilityEnumMap, json['ability']),
  modifier: (json['modifier'] as num).toInt(),
);

Map<String, dynamic> _$EntityEffectAbilityModifierToJson(
  EntityEffectAbilityModifier instance,
) => <String, dynamic>{
  'uuid': instance.uuid,
  'name': instance.name,
  'trigger': _$EntityEffectTriggerEnumMap[instance.trigger]!,
  'trigger_ticker_event': instance.triggerTickerEvent?.toJson(),
  'duration': instance.duration?.toJson(),
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
  'elapsed_duration_units': instance.elapsedDurationUnits,
  'active': instance.active,
  'ability': _$AbilityEnumMap[instance.ability]!,
  'modifier': instance.modifier,
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

const _$AbilityEnumMap = {
  Ability.force: 'force',
  Ability.intelligence: 'intelligence',
  Ability.coordination: 'coordination',
  Ability.presence: 'presence',
  Ability.resistance: 'resistance',
  Ability.volonte: 'volonte',
  Ability.perception: 'perception',
  Ability.empathie: 'empathie',
};
