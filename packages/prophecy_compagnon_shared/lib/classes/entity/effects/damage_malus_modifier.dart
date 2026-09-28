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
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'damage_malus_modifier.g.dart';

class EntityEffectDamageMalusModifierConfiguration extends EntityEffectConfiguration {
  const EntityEffectDamageMalusModifierConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowRequiredResult,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
    this.value = 0,
  })
    : super(target: EntityEffectTarget.damageMalusModifier);

  final int value;

  @override
  EntityEffect create() => EntityEffectDamageMalusModifier(
    name: name,
    trigger: trigger,
    triggerTickerEvent: triggerTickerEvent,
    duration: duration,
    activationDiceThrowRequest: activationDiceThrowRequest,
    activationDiceThrowRequiredResult: activationDiceThrowRequiredResult,
    activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
    postEffects: postEffects,
    removeOnUnapply: removeOnUnapply,
    value: value,
  );
}

@JsonSerializable()
class EntityEffectDamageMalusModifier extends EntityEffect {
  EntityEffectDamageMalusModifier({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowRequiredResult,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
    super.elapsedDurationUnits,
    super.active,
    int value = 0,
  })
    : _configuredValue = value,
      super(target: EntityEffectTarget.damageMalusModifier);

  int get value => _activationValue ?? _configuredValue;

  int _configuredValue;
  int? _activationValue;

  @override
  void setActivationDiceThrowValue(int v) => _activationValue = v;

  @override
  void unapply({required EntityBase target}) {
    _activationValue = null;
    super.unapply(target: target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectDamageMalusModifierToJson(this);

  factory EntityEffectDamageMalusModifier.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectDamageMalusModifierFromJson(json);
}