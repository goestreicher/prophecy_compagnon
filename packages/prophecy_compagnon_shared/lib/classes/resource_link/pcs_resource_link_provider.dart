/*
 * Copyright (C) 2025-2026 Grégory Oestreicher
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

import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/table.dart';

class PlayerCharactersResourceLinkProvider extends ResourceLinkProvider {
  const PlayerCharactersResourceLinkProvider({
    required this.tableUuid,
    required this.tableName,
  });

  final String tableUuid;
  final String tableName;

  @override
  List<String> sourceNames() => ['Table $tableName'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.pc,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.pc) {
      var table = await GameTableStore().get(tableUuid);
      if(table != null) {
        ret.addAll(
          table.playerSummaries
            .map((PlayerCharacterSummary summ) =>
              ResourceLink.createLinkForResource(type, true, summ.name, summ.id)
            )
        );
      }
    }

    return ret;
  }
}