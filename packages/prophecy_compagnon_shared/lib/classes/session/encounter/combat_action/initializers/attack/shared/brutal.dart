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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';

class ActionInitializerAttackBrutal extends ActionInitializerAttack {
  ActionInitializerAttackBrutal({
    required super.weapon,
    required super.target,
    required this.icon,
  });

  @override
  String get name => CombatActionAttackBaseType.brutal.title;

  @override
  final IconData icon;

  @override
  int get attackDifficulty => 15;

  @override
  int get dodgeDifficulty => 10;

  @override
  int get parryDifficulty => 15;

  @override
  int get damageModifier => _strengthModifier;

  late int _strengthModifier;

  @override
  Future<void> plan(BuildContext context, SessionEncounterEntityAction action) async {
    if((weapon.model as WeaponModel).handiness == 2) {
      _strengthModifier = 2 * action.entity.abilities.force;
    }
    else {
      _strengthModifier = action.entity.abilities.force;
    }

    await super.plan(context, action);
  }
}