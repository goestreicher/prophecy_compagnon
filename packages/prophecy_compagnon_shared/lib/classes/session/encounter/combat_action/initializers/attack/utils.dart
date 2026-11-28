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

import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/enums.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/shield.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_contact.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_distance.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_melee.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/descriptions/attack_ranged.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/attack.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/shared/brutal.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/shared/precise.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/initializers/attack/shared/simple.dart';

List<ActionInitializerAttack> getAttackInitializersForWeapon({
    required EntityBase attacker,
    required Weapon weapon,
    required EntityBase target,
}) {
  var ret = <ActionInitializerAttack>[];

  switch(weapon.range) {
    case WeaponRange.contact:
      // TODO: manage grappling here
      for(var t in CombatActionAttackContactType.values) {
        ActionInitializerAttack initializer;
        switch(t) {
          case CombatActionAttackContactType.simple:
            initializer = ActionInitializerAttackSimple(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackContactType.brutal:
            initializer = ActionInitializerAttackBrutal(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackContactType.precise:
            initializer = ActionInitializerAttackPrecise(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
        }
        ret.add(initializer);
      }
    case WeaponRange.melee:
      for(var t in CombatActionAttackMeleeType.values) {
        ActionInitializerAttack initializer;
        switch(t) {
          case CombatActionAttackMeleeType.simple:
            initializer = ActionInitializerAttackSimple(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackMeleeType.brutal:
            initializer = ActionInitializerAttackBrutal(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackMeleeType.precise:
            initializer = ActionInitializerAttackPrecise(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
        }
        ret.add(initializer);
      }
    case WeaponRange.distance:
      for(var t in CombatActionAttackDistanceType.values) {
        ActionInitializerAttack initializer;
        switch(t) {
          case CombatActionAttackDistanceType.simple:
            initializer = ActionInitializerAttackSimple(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackDistanceType.brutal:
            initializer = ActionInitializerAttackBrutal(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackDistanceType.precise:
            initializer = ActionInitializerAttackPrecise(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
        }
        ret.add(initializer);
      }
    case WeaponRange.ranged:
      for(var t in CombatActionAttackRangedType.values) {
        ActionInitializerAttack initializer;
        switch(t) {
          case CombatActionAttackRangedType.simple:
            initializer = ActionInitializerAttackSimple(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
          case CombatActionAttackRangedType.precise:
            initializer = ActionInitializerAttackPrecise(
              attacker: attacker,
              weapon: weapon,
              target: target,
              icon: t.icon,
            );
        }
        ret.add(initializer);
      }
  }

  return ret;
}

List<CombatActionDefense> getAvailableDefenseCombatActions({
    required EntityBase target,
    required int rank,
    required bool weakHand,
}) {
  var ret = <CombatActionDefense>[];

  ret.add(
    CombatActionDefenseDodge(
      entityId: target.id,
      rank: rank,
    )
  );

  for(var eq in target.equiped().whereType<Shield>()) {
    ret.add(
      CombatActionDefenseParryShield(
        entityId: target.id,
        rank: rank,
        shield: eq,
      )
    );
  }

  List<EquipableItemSlot> usableHands;
  if(weakHand) {
    usableHands = [EquipableItemSlot.weakHand];
  }
  else {
    usableHands = [EquipableItemSlot.dominantHand, EquipableItemSlot.weakHand];
  }
  for(var hand in usableHands) {
    for(var dp in target.damageProviderForHand(hand).whereType<Weapon>()) {
      ret.add(
        CombatActionDefenseParryWeapon(
          entityId: target.id,
          rank: rank,
          weapon: dp,
        )
      );
    }
  }

  return ret;
}