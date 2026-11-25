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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/action_initializer.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';

part 'defense.g.dart';

abstract class CombatActionDefense extends CombatAction {
  CombatActionDefense({
    required super.entityId,
    required super.rank,
    required this.defenseType,
    super.effects,
  })
    : super(type: CombatActionType.defense);

  final CombatActionDefenseType defenseType;

  String get label => defenseType.title;

  @override
  ActionInitializer? initializer() => null;

  DiceThrowEntityBase diceThrowBase();
}

@JsonSerializable()
class CombatActionDefenseDodge extends CombatActionDefense {
  CombatActionDefenseDodge({
    required super.entityId,
    required super.rank,
  })
    : super(defenseType: CombatActionDefenseType.dodge);

  @override
  DiceThrowEntityBase diceThrowBase() => DiceThrowEntityBaseSkill(
    attribute: Attribute.physique,
    skill: Skill.esquive,
    ability: Ability.coordination,
  );

  factory CombatActionDefenseDodge.fromJson(Map<String, dynamic> json) =>
      _$CombatActionDefenseDodgeFromJson(json);

  @override
  Map<String, dynamic> combatActionToJson() =>
      _$CombatActionDefenseDodgeToJson(this);
}

@JsonSerializable()
class CombatActionDefenseParryShield extends CombatActionDefense {
  CombatActionDefenseParryShield({
    required super.entityId,
    required super.rank,
    required this.shield,
  })
    : super(defenseType: CombatActionDefenseType.parryShield);

  final Shield shield;

  @override
  DiceThrowEntityBase diceThrowBase() => DiceThrowEntityBaseSkill(
    attribute: Attribute.physique,
    skill: Skill.bouclier,
    ability: Ability.force,
  );

  factory CombatActionDefenseParryShield.fromJson(Map<String, dynamic> json) =>
      _$CombatActionDefenseParryShieldFromJson(json);

  @override
  Map<String, dynamic> combatActionToJson() =>
      _$CombatActionDefenseParryShieldToJson(this);
}

@JsonSerializable()
class CombatActionDefenseParryWeapon extends CombatActionDefense {
  CombatActionDefenseParryWeapon({
    required super.entityId,
    required super.rank,
    required this.weapon,
  })
    : super(defenseType: CombatActionDefenseType.parryWeapon);

  final Weapon weapon;

  @override
  String get label => '${defenseType.title} (${weapon.name})';

  @override
  DiceThrowEntityBase diceThrowBase() => DiceThrowEntityBaseSkill(
    attribute: Attribute.physique,
    specialization: (weapon.model as WeaponModel).skill,
    ability: (weapon.model as WeaponModel).ability,
  );

  factory CombatActionDefenseParryWeapon.fromJson(Map<String, dynamic> json) =>
      _$CombatActionDefenseParryWeaponFromJson(json);

  @override
  Map<String, dynamic> combatActionToJson() =>
      _$CombatActionDefenseParryWeaponToJson(this);
}