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
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'damage.g.dart';

@JsonSerializable()
class EntityEffectDamage extends EntityEffect {
  EntityEffectDamage({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.frequency,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.elapsedDurationUnits,
    super.removeOnUnapply,
    super.statusMessageTitle,
    super.statusMessageText,
    super.active,
    required this.amount,
    this.inflictedInjuryProperties,
  })
    : super(target: EntityEffectTarget.damage);

  final int amount;
  final InflictedInjuryProperties? inflictedInjuryProperties;

  @override
  void apply({ required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation }) {
    if(!canApply(target: target)) return;

    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);
    var inflicted = target.takeDamage(amount, properties: inflictedInjuryProperties);

    if((inflicted?.rank ?? -1) >= 0) {
      for (var pp in target.protectionProviders) {
        if (pp is! Armor) continue;
        pp.damages = pp.damages + 1;
      }
    }
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectDamageToJson(this);

  factory EntityEffectDamage.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectDamageFromJson(json);
}