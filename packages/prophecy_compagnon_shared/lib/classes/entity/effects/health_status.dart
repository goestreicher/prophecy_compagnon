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
import 'package:prophecy_compagnon_shared/classes/entity/health_status.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'health_status.g.dart';

class EntityEffectHealthStatusConfiguration extends EntityEffectConfiguration {
  const EntityEffectHealthStatusConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowRequiredResult,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    required this.status,
  })
      : super(target: EntityEffectTarget.healthStatus);

  final EntityHealthStatusFlag status;

  @override
  EntityEffect create() => EntityEffectHealthStatus(
      name: name,
      trigger: trigger,
      triggerTickerEvent: triggerTickerEvent,
      duration: duration,
      activationDiceThrowRequest: activationDiceThrowRequest,
      activationDiceThrowRequiredResult: activationDiceThrowRequiredResult,
      activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
      postEffects: postEffects,
      status: status
  );
}

@JsonSerializable()
class EntityEffectHealthStatus extends EntityEffect {
  EntityEffectHealthStatus({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowRequiredResult,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.elapsedDurationUnits,
    super.active,
    required this.status,
  })
    : super(
        target: EntityEffectTarget.healthStatus,
        removeOnUnapply: true,
      );

  final EntityHealthStatusFlag status;

  @override
  bool canApply({ required EntityBase target }) =>
      super.canApply(target: target)
      && !target.healthStatus.has(status);

  @override
  void apply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    if(!canApply(target: target)) return;

    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);
    target.healthStatus.add(status);
  }

  @override
  void unapply({ required EntityBase target }) {
    if(!canApply(target: target)) return;

    target.healthStatus.clear(status);
    super.unapply(target: target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectHealthStatusToJson(this);

  factory EntityEffectHealthStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectHealthStatusFromJson(json);
}