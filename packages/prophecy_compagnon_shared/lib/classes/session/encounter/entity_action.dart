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

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';
import 'package:uuid/uuid.dart';

enum SessionEncounterEntityActionStage {
  none,
  assigned,
  planned,
  approved,
  executed,
}

class SessionEncounterEntityAction {
  SessionEncounterEntityAction({
    String? uuid,
    required this.entity,
    required this.initialRank,
    this.weakHand = false,
    this.combatAction,
  })
    : uuid = uuid ?? Uuid().v4().toString();

  final String uuid;
  final EntityBase entity;
  int initialRank;
  int delayed = 0;
  bool weakHand;
  SessionEncounterEntityActionStage stage = SessionEncounterEntityActionStage.none;
  CombatAction? combatAction;

  int get rank => initialRank - delayed;

  bool canBeUsedFor(CombatActionType type) {
    if(
        stage != SessionEncounterEntityActionStage.none
        && stage != SessionEncounterEntityActionStage.assigned
    ) {
      return false;
    }

    // TODO: uncomment this once attack and defense types are enabled
    // if(weakHand) {
    //   return
    //     type == CombatActionType.attack
    //     || type == CombatActionType.defense;
    // }

    return true;
  }
}