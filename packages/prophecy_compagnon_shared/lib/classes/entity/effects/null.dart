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
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'null.g.dart';

class EntityEffectNullConfiguration extends EntityEffectConfiguration {
  const EntityEffectNullConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
  })
    : super(target: EntityEffectTarget.none);

  @override
  EntityEffect create() => EntityEffectNull(
    name: name,
    trigger: trigger,
    triggerTickerEvent: triggerTickerEvent,
    duration: duration,
    activationDiceThrowRequest: activationDiceThrowRequest,
    activationDiceThrowValidResults: activationDiceThrowValidResults,
    activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
    postEffects: postEffects,
    removeOnUnapply: removeOnUnapply,
  );
}

@JsonSerializable()
class EntityEffectNull extends EntityEffect {
  EntityEffectNull({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
    super.elapsedDurationUnits,
    super.active,
  })
    : super(target: EntityEffectTarget.none);

  @override
  bool canApply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) =>
      false;

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectNullToJson(this);

  factory EntityEffectNull.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectNullFromJson(json);
}