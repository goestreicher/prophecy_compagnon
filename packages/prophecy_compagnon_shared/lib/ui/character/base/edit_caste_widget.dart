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
import 'package:prophecy_compagnon_shared/classes/caste/base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterEditCasteWidget extends StatelessWidget {
  const CharacterEditCasteWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Caste',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        spacing: 12.0,
        children: [
          DropdownMenu<Caste>(
            requestFocusOnTap: true,
            label: const Text('Caste'),
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            initialSelection: character.caste.caste,
            onSelected: (Caste? caste) {
              if(caste == null) return;
              if(caste != character.caste.caste) character.caste.career = null;
              character.caste.caste = caste;
            },
            dropdownMenuEntries: Caste.values
              .map((Caste caste) => DropdownMenuEntry(value: caste, label: caste.title))
              .toList(),
          ),
          ValueListenableBuilder(
            valueListenable: character.caste.casteNotifier,
            builder: (BuildContext context, Caste caste, _) {
              final Map<CasteStatus, String> casteStatusLabels = <CasteStatus, String>{};
              if(caste == Caste.sansCaste) {
                casteStatusLabels[CasteStatus.none] = Caste.statusName(
                  Caste.sansCaste, CasteStatus.none
                );
              }
              else {
                for(var status in CasteStatus.values) {
                  casteStatusLabels[status] = Caste.statusName(
                    caste, status
                  );
                }
              }

              return DropdownMenu(
                requestFocusOnTap: true,
                label: const Text('Statut'),
                expandedInsets: EdgeInsets.zero,
                textStyle: theme.textTheme.bodySmall,
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  constraints: BoxConstraints(maxHeight: 36.0),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                initialSelection: character.caste.status,
                onSelected: (CasteStatus? status) {
                  if(status == null) return;
                  character.caste.status = status;
                },
                dropdownMenuEntries: casteStatusLabels.keys
                  .map((CasteStatus s) => DropdownMenuEntry(value: s, label: casteStatusLabels[s]!))
                  .toList(),
              );
            }
          ),
        ],
      )
    );
  }
}