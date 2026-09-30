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

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/dice/evaluate_dice_throw.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'injury_capacity.g.dart';

class EntityEffectInjuryCapacityConfiguration extends EntityEffectConfiguration {
  const EntityEffectInjuryCapacityConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.postEffects,
    super.removeOnUnapply,
    required this.damage,
  })
    : super(target: EntityEffectTarget.injuryCapacity);

  final Map<Injury, int> damage;

  @override
  EntityEffect create() => EntityEffectInjuryCapacity(
      name: name,
      trigger: trigger,
      triggerTickerEvent: triggerTickerEvent,
      duration: duration,
      activationDiceThrowRequest: activationDiceThrowRequest,
      activationDiceThrowValidResults: activationDiceThrowValidResults,
      postEffects: postEffects,
      removeOnUnapply: removeOnUnapply,
      damage: damage,
    );
}

@JsonSerializable()
class EntityEffectInjuryCapacity extends EntityEffect {
  EntityEffectInjuryCapacity({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.postEffects,
    super.removeOnUnapply,
    super.elapsedDurationUnits,
    super.active,
    required this.damage,
  })
    : super(target: EntityEffectTarget.injuryCapacity);

  final Map<Injury, int> damage;

  @override
  void apply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);

    for(var i in damage.entries) {
      target.injuries.manager.setCapacity(
        i.key,
        target.injuries.manager.capacity(i.key) + i.value,
      );
    }
  }

  @override
  void unapply({ required EntityBase target }) {
    for(var i in damage.entries) {
      target.injuries.manager.setCapacity(
        i.key,
        target.injuries.manager.capacity(i.key) - i.value,
      );
    }

    super.unapply(target: target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectInjuryCapacityToJson(this);

  factory EntityEffectInjuryCapacity.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectInjuryCapacityFromJson(json);
}