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
import 'package:prophecy_compagnon_shared/classes/entity/combat_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'combat_status.g.dart';

class EntityEffectCombatStatusConfiguration extends EntityEffectConfiguration {
  const EntityEffectCombatStatusConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    required this.status,
  })
    : super(target: EntityEffectTarget.combatStatus);

  final EntityCombatStatusFlag status;

  @override
  EntityEffect create() => EntityEffectCombatStatus(
      name: name,
      trigger: trigger,
      triggerTickerEvent: triggerTickerEvent,
      duration: duration,
      activationDiceThrowRequest: activationDiceThrowRequest,
      activationDiceThrowValidResults: activationDiceThrowValidResults,
      activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
      postEffects: postEffects,
      status: status
  );
}

@JsonSerializable()
class EntityEffectCombatStatus extends EntityEffect {
  EntityEffectCombatStatus({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.elapsedDurationUnits,
    required this.status,
  })
    : super(
        target: EntityEffectTarget.combatStatus,
        active: true,
        removeOnUnapply: true,
      );

  final EntityCombatStatusFlag status;

  @override
  bool canApply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) =>
      super.canApply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation)
      && !target.combatStatus.has(status);

  @override
  void apply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    if(!canApply(target: target)) return;

    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);
    target.combatStatus.add(status);
  }

  @override
  void unapply({ required EntityBase target }) {
    target.combatStatus.clear(status);
    super.unapply(target: target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectCombatStatusToJson(this);

  factory EntityEffectCombatStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectCombatStatusFromJson(json);
}