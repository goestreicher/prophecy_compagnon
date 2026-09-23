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
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'global_dice_throw_modifier.g.dart';

class EntityEffectGlobalDiceThrowModifierConfiguration extends EntityEffectConfiguration {
  const EntityEffectGlobalDiceThrowModifierConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    required this.modifier,
  })
    : super(target: EntityEffectTarget.diceThrowModifier);

  final int modifier;

  @override
  EntityEffect create() => EntityEffectGlobalDiceThrowModifier(
      name: name,
      trigger: trigger,
      triggerTickerEvent: triggerTickerEvent,
      duration: duration,
      modifier: modifier
    );
}

@JsonSerializable()
class EntityEffectGlobalDiceThrowModifier extends EntityEffect {
  EntityEffectGlobalDiceThrowModifier({
    super.uuid,
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.postEffects,
    super.removeOnUnapply,
    super.elapsedDurationUnits,
    super.active,
    required this.modifier,
    this.modifierId,
  })
    : super(target: EntityEffectTarget.diceThrowModifier);

  final int modifier;
  String? modifierId;

  @override
  void apply(EntityBase target) {
    super.apply(target);

    var mod = OneOffDiceThrowModifier(
      type: DiceThrowModifierType.malus,
      family: DiceThrowModifierFamily.disadvantage,
      label: name,
      value: modifier,
      name: uuid,
    );
    modifierId = mod.id;

    target.addThrowModifier(mod);
  }

  @override
  void unapply(EntityBase target) {
    target.removeThrowModifier(modifierId!);

    super.unapply(target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectGlobalDiceThrowModifierToJson(this);

  factory EntityEffectGlobalDiceThrowModifier.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectGlobalDiceThrowModifierFromJson(json);
}