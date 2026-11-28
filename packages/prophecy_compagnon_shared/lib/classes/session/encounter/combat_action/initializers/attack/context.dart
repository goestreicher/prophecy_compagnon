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

import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/injury.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/weapon.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/attack_context.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action/implementations/defense.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/messages/session_message.dart';

class ActionInitializerAttackContext {
  ActionInitializerAttackContext({
    required this.attacker,
    required this.weapon,
    required this.target,
  });

  final EntityBase attacker;
  final Weapon weapon;
  final EntityBase target;

  late DiceThrowRequest attackRequest;
  int cumulativeAttackMalus = -5;

  SessionEncounterEntityAction? defenseAction;
  CombatActionDefense? defenseCombatAction;
  DiceThrowRequest? defenseRequest;
  int? cumulativeDefenseMalus;

  int damage = 0;
  InflictedInjuryProperties? inflictedInjuryProperties;
  String? damageEffectMessageTitle;
  String? damageEffectMessageText;
  final List<SessionMessage> attackEffects = <SessionMessage>[];
  bool ignoreArmor = false;

  CombatActionAttackContext toCombatActionAttackContext() =>
    CombatActionAttackContext(
      cumulativeAttackMalus: cumulativeAttackMalus,
      targetId: target.id,
      cumulativeDefenseMalus: cumulativeDefenseMalus,
    );
}