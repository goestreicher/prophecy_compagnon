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
import 'package:material_symbols_icons/symbols.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/sourced_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/ui/resource_link_picker_dialog.dart';

Widget resourceLinkNameAutocompleteWidget(
    BuildContext context,
    void Function(String) onInput,
    List<ResourceLinkType> types,
) {
  var theme = Theme.of(context);

  return ListView(
    shrinkWrap: true,
    children: [
      ListTile(
        leading: Icon(Symbols.person),
        title: const Text('Sélectionner un PNJ existant'),
        tileColor: theme.colorScheme.surfaceBright,
        onTap: () async {
          var r = await showDialog<ResourceLink?>(
            context: context,
            builder: (BuildContext context) {
              return ResourceLinkPickerDialog(
                restrictToTypes: types,
                localProvider: SourcedResourceLinkProvider(
                  source: ObjectSource.local,
                ),
              );
            }
          );

          if(r != null) onInput(r.name);
        },
      ),
    ],
  );
}

Widget characterNameAutocompleteWidget(BuildContext context, void Function(String) onInput) {
  return resourceLinkNameAutocompleteWidget(
      context,
      onInput,
      [
        ResourceLinkType.npc,
        ResourceLinkType.pc,
      ]
  );
}