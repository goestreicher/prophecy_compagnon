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

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/combat.dart';
import 'package:prophecy_compagnon_shared/classes/entity_instance.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/engagements_manager.dart';
import 'package:prophecy_compagnon_shared/classes/session/encounter/turn.dart';

enum SessionEncounterStatus {
  positioning,
  ready,
  ongoing,
  finished,
}

// TODO: make this exportable to JSON
class SessionEncounter with ChangeNotifier {
  SessionEncounter({
    required this.name,
    required this.characters,
    required this.npcs,
    List<SessionEncounterTurn>? turns,
    List<(String, String, WeaponRange)>? engagements,
  })
    : _status = SessionEncounterStatus.positioning,
      turns = turns ?? <SessionEncounterTurn>[],
      engagements = EngagementsManager(engagements);

  final String name;
  final List<PlayerCharacter> characters;
  final List<EntityInstance> npcs;
  final List<SessionEncounterTurn> turns;
  final EngagementsManager engagements;

  SessionEncounterStatus get status => _status;
  set status(SessionEncounterStatus s) {
    _status = s;
    notifyListeners();
  }
  SessionEncounterStatus _status;

  void removePlayerCharacter(String id) {
    characters.removeWhere((PlayerCharacter e) => e.id == id);
  }

  void removeNpc(String id) {
    npcs.removeWhere(
      (EntityInstance e) {
        if(e.id == id) {
          EntityInstanceStore().delete(e);
          return true;
        }
        return false;
      }
    );
  }

  int get currentTurnNumber => turns.isEmpty ? 0 : turns.length;

  SessionEncounterTurn? get currentTurn => turns.isEmpty ? null : turns.last;
}