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
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'luck_modifier.g.dart';

class EntityEffectLuckModifierConfiguration extends EntityEffectConfiguration {
  const EntityEffectLuckModifierConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
    required this.value,
  })
    : super(target: EntityEffectTarget.luckModifier);

  final int value;

  @override
  EntityEffect create() => EntityEffectLuckModifier(
    name: name,
    trigger: trigger,
    triggerTickerEvent: triggerTickerEvent,
    duration: duration,
    activationDiceThrowRequest: activationDiceThrowRequest,
    activationDiceThrowValidResults: activationDiceThrowValidResults,
    activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
    postEffects: postEffects,
    removeOnUnapply: removeOnUnapply,
    value: value,
  );
}

@JsonSerializable()
class EntityEffectLuckModifier extends EntityEffect {
  EntityEffectLuckModifier({
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
    required this.value,
  })
    : super(target: EntityEffectTarget.luckModifier);

  final int value;

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectLuckModifierToJson(this);

  factory EntityEffectLuckModifier.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectLuckModifierFromJson(json);
}