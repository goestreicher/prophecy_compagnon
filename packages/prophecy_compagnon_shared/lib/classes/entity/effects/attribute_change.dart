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
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'attribute_change.g.dart';

@JsonSerializable()
class EntityEffectChangeAttribute extends EntityEffect {
  EntityEffectChangeAttribute({
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
    super.removeOnUnapply,
    super.statusMessageTitle,
    super.statusMessageText,
    super.elapsedDurationUnits,
    super.active,
    required this.attribute,
    required this.delta,
  })
    : super(target: EntityEffectTarget.attribute);

  final Attribute attribute;
  final int delta;

  @override
  void apply({required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation}) {
    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);

    int v = target.attributes[attribute] + delta;
    if(v < 0) v = 0;
    target.attributes.setAttribute(attribute, v);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectChangeAttributeToJson(this);

  factory EntityEffectChangeAttribute.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectChangeAttributeFromJson(json);
}