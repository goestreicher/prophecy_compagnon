// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_throw_modifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityEffectGlobalDiceThrowModifier
_$EntityEffectGlobalDiceThrowModifierFromJson(Map<String, dynamic> json) =>
    EntityEffectGlobalDiceThrowModifier(
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
      type: $enumDecode(_$DiceThrowModifierTypeEnumMap, json['type']),
      family: $enumDecode(_$DiceThrowModifierFamilyEnumMap, json['family']),
      modifier: (json['modifier'] as num).toInt(),
      modifierId: json['modifier_id'] as String?,
      alwaysApply: json['always_apply'] as bool? ?? true,
    );

Map<String, dynamic> _$EntityEffectGlobalDiceThrowModifierToJson(
  EntityEffectGlobalDiceThrowModifier instance,
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
  'type': _$DiceThrowModifierTypeEnumMap[instance.type]!,
  'family': _$DiceThrowModifierFamilyEnumMap[instance.family]!,
  'modifier': instance.modifier,
  'modifier_id': instance.modifierId,
  'always_apply': instance.alwaysApply,
};

const _$EntityEffectTriggerEnumMap = {
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

const _$DiceThrowModifierTypeEnumMap = {
  DiceThrowModifierType.bonus: 'bonus',
  DiceThrowModifierType.malus: 'malus',
  DiceThrowModifierType.difficulty: 'difficulty',
};

const _$DiceThrowModifierFamilyEnumMap = {
  DiceThrowModifierFamily.advantage: 'advantage',
  DiceThrowModifierFamily.context: 'context',
  DiceThrowModifierFamily.criticalDiceThrow: 'criticalDiceThrow',
  DiceThrowModifierFamily.damage: 'damage',
  DiceThrowModifierFamily.disadvantage: 'disadvantage',
  DiceThrowModifierFamily.healthStatus: 'healthStatus',
  DiceThrowModifierFamily.movementPenalty: 'movementPenalty',
};
