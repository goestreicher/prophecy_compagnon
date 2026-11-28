/*
 * Copyright (C) 2026 Grégory Oestreicher
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/game_session.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';
import 'package:uuid/uuid.dart';

part 'effect.g.dart';

enum EntityEffectTrigger {
  diceThrow,
  once,
  permanent,
  request,
  tickerEvent,
  ;
}

enum EntityEffectTarget {
  ability,
  abilityModifier,
  attribute,
  attributeModifier,
  combatStatus,
  damage,
  damageArmor,
  damageMalusModifier,
  diceThrowModifier,
  disadvantage,
  experience,
  healthStatus,
  initiativeExtraDice,
  injury,
  injuryCapacity,
  luck,
  luckModifier,
  none,
  proficiency,
  tendencyCircles,
  ;
}

class EntityEffectBuilderArgs {
  EntityEffectBuilderArgs({
    required this.cost,
    required this.details,
  });

  final int cost;
  final String details;
}

typedef EntityEffectBuilder =
    List<EntityEffect> Function(EntityEffectBuilderArgs);

typedef EntityEffectJsonFactory = EntityEffect Function(Map<String, dynamic>);

abstract class EntityEffectConfiguration{
  const EntityEffectConfiguration({
    required this.name,
    required this.target,
    required this.trigger,
    this.triggerTickerEvent,
    this.duration,
    this.frequency,
    this.activationDiceThrowRequest,
    this.activationDiceThrowValidResults = const [DiceThrowResultType.success],
    this.activationDiceThrowValueTransformer,
    List<EntityEffect>? postEffects,
    this.removeOnUnapply = false,
  })
    : postEffects = postEffects ?? const <EntityEffect>[];

  final String name;
  final EntityEffectTarget target;
  final EntityEffectTrigger trigger;
  final TickerEvent? triggerTickerEvent;
  final TickerEvent? duration;
  final TickerEvent? frequency;
  final DiceThrowRequest? activationDiceThrowRequest;
  final List<DiceThrowResultType> activationDiceThrowValidResults;
  final EntityEffectActivationDiceThrowValueTransformer? activationDiceThrowValueTransformer;
  final List<EntityEffect> postEffects;
  final bool removeOnUnapply;

  EntityEffect create();
}

@JsonSerializable()
class EntityEffectActivationDiceThrowValueTransformer {
  const EntityEffectActivationDiceThrowValueTransformer({
    this.base = 0,
    this.nrMultiplier = 0,
  });

  final int base;
  final int nrMultiplier;

  int value(DiceThrowEvaluation evaluation) =>
      base
      + evaluation.nr * nrMultiplier;

  factory EntityEffectActivationDiceThrowValueTransformer.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectActivationDiceThrowValueTransformerFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityEffectActivationDiceThrowValueTransformerToJson(this);
}

abstract class EntityEffect {
  EntityEffect({
    String? uuid,
    required this.name,
    required this.target,
    required this.trigger,
    this.triggerTickerEvent,
    this.duration,
    this.frequency,
    this.activationDiceThrowRequest,
    this.activationDiceThrowValidResults = const [DiceThrowResultType.success],
    this.activationDiceThrowValueTransformer,
    List<EntityEffect>? postEffects,
    this.removeOnUnapply = false,
    this.statusMessageTitle,
    this.statusMessageText,
    this.elapsedTriggerUnits = 0,
    this.elapsedDurationUnits,
    bool active = false,
  })
    : uuid = uuid ?? Uuid().v4().toString(),
      postEffects = postEffects ?? <EntityEffect>[],
      _active = active;

  final String uuid;
  final String name;
  final EntityEffectTarget target;
  final EntityEffectTrigger trigger;
  final TickerEvent? triggerTickerEvent;
  final TickerEvent? duration;
  final TickerEvent? frequency;
  final DiceThrowRequest? activationDiceThrowRequest;
  final List<DiceThrowResultType> activationDiceThrowValidResults;
  final EntityEffectActivationDiceThrowValueTransformer? activationDiceThrowValueTransformer;
  final List<EntityEffect> postEffects;
  final bool removeOnUnapply;
  final String? statusMessageTitle;
  final String? statusMessageText;
  int elapsedTriggerUnits;
  int? elapsedDurationUnits;
  int? elapsedFrequencyUnits;
  bool _active;

  Map<String, dynamic> effectToJson();

  bool canApply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    if(_active && frequency == null) {
      return false;
    }

    if(activationDiceThrowRequest != null) {
      return
          activationDiceThrowEvaluation != null
          && activationDiceThrowValidResults.contains(activationDiceThrowEvaluation.resultType);
    }

    if(triggerTickerEvent != null) {
      return false;
    }

    return true;
  }

  void setActivationDiceThrowValue(int v) {}

  @mustCallSuper
  void apply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    if(!_active && duration != null) {
      elapsedDurationUnits = 0;
    }

    if(_active && frequency != null) {
      elapsedFrequencyUnits = 0;
    }

    if(
        activationDiceThrowRequest != null
        && activationDiceThrowValueTransformer != null
        && activationDiceThrowEvaluation != null
        && activationDiceThrowValidResults.contains(activationDiceThrowEvaluation.resultType)
    ) {
      setActivationDiceThrowValue(
        activationDiceThrowValueTransformer!.value(
          activationDiceThrowEvaluation
        )
      );
    }

    if(statusMessageText != null) {
      GameSession.instance?.chat.post(
        title: statusMessageTitle ?? "Effet appliqué : $name",
        text: statusMessageText!,
      );
    }

    active = true;
  }

  @mustCallSuper
  void unapply({ required EntityBase target }) {
    if(duration != null) {
      elapsedDurationUnits = null;
    }

    if(frequency != null) {
      elapsedFrequencyUnits = null;
    }

    for(var effect in postEffects) {
      target.effects.add(effect);
      effect.apply(target: target);
    }

    active = false;

    if(statusMessageText != null) {
      GameSession.instance?.chat.post(
        title: statusMessageTitle ?? "Effet désappliqué : $name",
        text: statusMessageText!,
      );
    }
  }

  String get id => uuid;

  bool get active => trigger == EntityEffectTrigger.permanent || _active;
  set active(bool v) => _active = v;

  @mustCallSuper
  void tick(TickerEvent event) {
    _tickTrigger(event);
    _tickDuration(event);
    _tickFrequency(event);
  }

  bool get becameActive =>
      triggerTickerEvent != null
      && elapsedTriggerUnits >= triggerTickerEvent!.count;

  bool get frequencyReApply =>
      frequency != null
      && elapsedFrequencyUnits != null
      && elapsedFrequencyUnits! >= frequency!.count;

  bool get expired {
    if(duration == null) {
      if(triggerTickerEvent == null) {
        return true;
      }
      else {
        return becameActive;
      }
    }
    else {
      return
        elapsedDurationUnits != null
        && elapsedDurationUnits! >= duration!.count;
    }
  }

  void _tickTrigger(TickerEvent event) {
    if(triggerTickerEvent == null) return;
    if(triggerTickerEvent!.type != TickerEventType.end) return;
    if(_active) return;

    elapsedTriggerUnits = elapsedTriggerUnits + 1;
  }

  void _tickDuration(TickerEvent event) {
    if(duration == null) return;
    if(duration!.type != TickerEventType.end) return;
    if(!_active) return;

    // TODO: manage ticker events with a higher duration unit
    elapsedDurationUnits = elapsedDurationUnits! + 1;
  }

  void _tickFrequency(TickerEvent event) {
    if(frequency == null) return;
    if(frequency!.type != TickerEventType.end) return;
    if(!_active) return;

    // TODO: manage ticker events with a higher duration unit
    elapsedFrequencyUnits = elapsedFrequencyUnits! + 1;
  }

  factory EntityEffect.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('_type')) {
      throw(ArgumentError('Missing "_type" key in JSON'));
    }
    return _effectFactories[json['_type']]!(json);
  }

  Map<String, dynamic> toJson() {
    var ret = effectToJson();
    ret['_type'] = runtimeType.toString();
    return ret;
  }

  static void registerEntityEffectJsonFactory(String name, EntityEffectJsonFactory factory) =>
      _effectFactories[name] = factory;

  static final Map<String, EntityEffectJsonFactory> _effectFactories =
      <String, EntityEffectJsonFactory>{};
}

class EntityEffects with Iterable<EntityEffect>, ChangeNotifier {
  EntityEffects({
    List<EntityEffect>? effects,
  })
    : _all = effects ?? <EntityEffect>[];

  @override
  Iterator<EntityEffect> get iterator => _all.iterator;

  void add(EntityEffect effect) {
    // Effects that trigger only once when added are not saved for long-term use
    if(
        effect.trigger == EntityEffectTrigger.once
        && effect.triggerTickerEvent == null
        && effect.activationDiceThrowRequest == null
    ) {
      return;
    }

    if(_all.any((EntityEffect e) => e.id == effect.id)) {
      return;
    }

    _all.add(effect);
    notifyListeners();
  }

  void remove(EntityEffect effect) {
    _all.remove(effect);
    notifyListeners();
  }

  Iterable<EntityEffect> forTarget(EntityEffectTarget target) =>
      _all
        .where((EntityEffect e) => e.target == target);

  static EntityEffects fromJson(List<dynamic>? json) =>
      EntityEffects(
        effects: (json ?? [])
          .map<EntityEffect>(
            (e) => EntityEffect.fromJson(e as Map<String, dynamic>),
          )
          .toList()
      );

  static List<Map<String, dynamic>> toJson(EntityEffects effects) =>
      effects
        .map((EntityEffect e) => e.toJson())
        .toList();

  final List<EntityEffect> _all;
}