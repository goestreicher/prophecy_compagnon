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
import 'package:prophecy_compagnon_shared/classes/session/encounter/entity_action.dart';

class SessionEncounterTurn {
  SessionEncounterTurn({
    required this.actions,
  })
  {
    var ranks = ranksWithActionFilter((SessionEncounterEntityAction a) => true)
      .toList()
      ..sort((int a, int b) => b - a);
    currentRank = ranks.isNotEmpty ? ranks.first : -1;

    Set<String> listenedIds = {};
    for(var a in actions) {
      if(listenedIds.contains(a.entity.id)) continue;
      a.entity.healthStatus.addListener(
          () => _onEntityHealthStatusChanged(a.entity)
      );
      listenedIds.add(a.entity.id);
    }
  }

  final List<SessionEncounterEntityAction> actions;
  late int currentRank;

  Iterable<SessionEncounterEntityAction> filteredActions(
      bool Function(SessionEncounterEntityAction) filter
  ) =>
      actions.where((SessionEncounterEntityAction a) => filter(a));

  Iterable<int> ranksWithActionFilter(
      bool Function(SessionEncounterEntityAction) filter
  ) =>
      filteredActions(filter)
        .map((SessionEncounterEntityAction a) => a.rank)
        .toSet()
        .toList()
        ..sort((int a, int b) => b - a);

  Iterable<SessionEncounterEntityAction> actionsForRank(int rank) => actions
      .where((SessionEncounterEntityAction a) => a.rank == rank);

  void _onEntityHealthStatusChanged(EntityBase entity) {
    if(!entity.canAct()) {
      actions.removeWhere(
          (SessionEncounterEntityAction a) =>
              a.entity.id == entity.id
              && a.rank < currentRank
      );
    }
  }
}