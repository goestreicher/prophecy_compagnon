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

import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/faction.dart';
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/classes/object_location.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/place.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';

class SourcedResourceLinkProvider extends ResourceLinkProvider {
  const SourcedResourceLinkProvider({ required this.source });

  final ObjectSource source;

  @override
  List<String> sourceNames() => ['${source.type.title} > ${source.name}'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.creature,
    ResourceLinkType.faction,
    ResourceLinkType.npc,
    ResourceLinkType.place,
    ResourceLinkType.star,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.creature) {
      ret.addAll(
        (await CreatureSummary.forSource(source, null))
        .map((CreatureSummary summ) =>
          ResourceLink.createLinkForResource(
            type,
            !(summ.location.type == ObjectLocationType.assets),
            summ.name,
            summ.id
          )
        )
      );
    }
    else if(type == ResourceLinkType.faction) {
      await _createFactionLinkTree(null, ret, '');
    }
    else if(type == ResourceLinkType.npc) {
      ret.addAll(
        (await NonPlayerCharacterSummary.forSource(source, null, null))
        .map((NonPlayerCharacterSummary summ) =>
          ResourceLink.createLinkForResource(
              type,
              !(summ.location.type == ObjectLocationType.assets),
              summ.name,
              summ.id
          )
        )
      );
    }
    else if(type == ResourceLinkType.place) {
      await _createPlaceLinkTree('monde', ret, '');
    }
    else if(type == ResourceLinkType.star) {
      ret.addAll(
        (await Star.forSource(source))
        .map((Star star) =>
          ResourceLink.createLinkForResource(
            type,
            !(star.location.type == ObjectLocationType.assets),
            star.name,
            star.id
          )
        )
      );
    }

    return ret;
  }

  Future<void> _createFactionLinkTree(String? parent, List<ResourceLink> links, String prefix) async {
    for(FactionSummary summ in (await FactionSummary.withParent(parent))) {
      String display = '$prefix${summ.name}';
      if(!summ.displayOnly) {
        var link = ResourceLink.createLinkForResource(
          ResourceLinkType.faction,
          !(summ.location.type == ObjectLocationType.assets),
          summ.name,
          summ.id,
          label: display
        );
        if (summ.source != source) {
          link.clickable = false;
        }
        links.add(link);
      }
      await _createFactionLinkTree(summ.id, links, '$prefix${summ.name} > ');
    }
  }

  Future<void> _createPlaceLinkTree(String parent, List<ResourceLink> links, String prefix) async {
    for(PlaceSummary summ in (await PlaceSummary.withParent(parent))) {
      String display = '$prefix${summ.name}';
      var link = ResourceLink.createLinkForResource(
        ResourceLinkType.place,
        !(summ.location.type == ObjectLocationType.assets),
        summ.name,
        summ.id,
        label: display
      );
      if(summ.source != source) {
        link.clickable = false;
      }
      links.add(link);
      await _createPlaceLinkTree(summ.id, links, '$prefix${summ.name} > ');
    }
  }
}