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
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/ticker.dart';

part 'ability_modifier.g.dart';

class EntityEffectAbilityModifierConfiguration extends EntityEffectConfiguration {
  const EntityEffectAbilityModifierConfiguration({
    required super.name,
    required super.trigger,
    super.triggerTickerEvent,
    super.duration,
    super.activationDiceThrowRequest,
    super.activationDiceThrowValidResults,
    super.activationDiceThrowValueTransformer,
    super.postEffects,
    super.removeOnUnapply,
    required this.ability,
    required this.modifier,
  })
    : super(target: EntityEffectTarget.abilityModifier);

  final Ability ability;
  final int modifier;

  @override
  EntityEffect create() => EntityEffectAbilityModifier(
    name: name,
    trigger: trigger,
    triggerTickerEvent: triggerTickerEvent,
    duration: duration,
    activationDiceThrowRequest: activationDiceThrowRequest,
    activationDiceThrowValidResults: activationDiceThrowValidResults,
    activationDiceThrowValueTransformer: activationDiceThrowValueTransformer,
    postEffects: postEffects,
    removeOnUnapply: removeOnUnapply,
    ability: ability,
    modifier: modifier,
  );
}

@JsonSerializable()
class EntityEffectAbilityModifier extends EntityEffect {
  EntityEffectAbilityModifier({
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
    required this.ability,
    required this.modifier,
  })
    : _impactedAttributeDelta = 0, super(target: EntityEffectTarget.abilityModifier);

  final Ability ability;
  final int modifier;
  Attribute? _impactedAttribute;
  int _impactedAttributeDelta;

  @override
  void apply({required EntityBase target, DiceThrowEvaluation? activationDiceThrowEvaluation}) {
    super.apply(target: target, activationDiceThrowEvaluation: activationDiceThrowEvaluation);

    for(var attr in Attribute.values) {
      if(attr.relatedAbilities.contains(ability)) {
        _impactedAttribute = attr;
      }
    }

    var previousModifier = EntityAttributes.attributeModifier(
        _impactedAttribute!,
        target.abilities.all
      )
      ?? 0;

    target.abilities.setAbility(
      ability,
      target.abilities[ability] + modifier
    );

    var currentModifier = EntityAttributes.attributeModifier(
        _impactedAttribute!,
        target.abilities.all
      )
      ?? 0;
    _impactedAttributeDelta = currentModifier - previousModifier;

    if(_impactedAttributeDelta != 0) {
      target.attributes.setAttribute(
        _impactedAttribute!,
        target.attributes[_impactedAttribute!] + _impactedAttributeDelta
      );
    }

    // TODO: implement apply
  }

  @override
  void unapply({required EntityBase target}) {
    target.abilities.setAbility(
      ability,
      target.abilities[ability] - modifier
    );

    if(_impactedAttributeDelta != 0) {
      target.attributes.setAttribute(
        _impactedAttribute!,
        target.attributes[_impactedAttribute!] - _impactedAttributeDelta
      );
    }

    super.unapply(target: target);
  }

  @override
  Map<String, dynamic> effectToJson() =>
      _$EntityEffectAbilityModifierToJson(this);

  factory EntityEffectAbilityModifier.fromJson(Map<String, dynamic> json) =>
      _$EntityEffectAbilityModifierFromJson(json);
}