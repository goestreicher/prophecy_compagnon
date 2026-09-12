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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_encounter.dart';
import 'package:prophecy_compagnon_shared/ui/scenario/encounter_display_widget.dart';

Future<Widget?> handleEncounterLinkClicked(
    ResourceLink link,
    BuildContext context,
    {
      List<Widget>? extraActionButtons,
    }
) async {
  var scenario = await ScenarioStore().get(link.uri.pathSegments[1]);
  if(scenario == null) {
    return AlertDialog(
      title: const Text('Scénario non trouvé'),
      content: Text(
          "Impossible de trouver le scénario avec l'ID ${link.uri.pathSegments[1]}"
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }

  ScenarioEncounter? encounter;
  for(var e in scenario.encounters) {
    if(e.uuid == link.id) {
      encounter = e;
      break;
    }
  }

  if(encounter == null) {
    return AlertDialog(
      title: const Text('Rencontre non trouvée'),
      content: Text(
          "Impossible de trouver la rencontre avec l'ID ${link.id}"
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('OK')
        ),
      ],
    );
  }
  else {
    return AlertDialog(
      title: Text('Rencontre ${link.name}'),
      content: SizedBox(
        width: 400,
        child: ScenarioEncounterDisplayWidget(encounter: encounter),
      ),
      actions: [
        ...?extraActionButtons,
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }
}