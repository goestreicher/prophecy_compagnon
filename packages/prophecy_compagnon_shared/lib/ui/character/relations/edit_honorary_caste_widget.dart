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
import 'package:prophecy_compagnon_shared/classes/caste/character_caste.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterEditHonoraryCasteWidget extends StatefulWidget {
  const CharacterEditHonoraryCasteWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  State<CharacterEditHonoraryCasteWidget> createState() => _CharacterEditHonoraryCasteWidgetState();
}

class _CharacterEditHonoraryCasteWidgetState extends State<CharacterEditHonoraryCasteWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
        title: Text(
          'Caste Honoraire',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Column(
          spacing: 16.0,
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
              initialSelection: widget.character.honoraryCaste?.caste ?? Caste.sansCaste,
              onSelected: (Caste? caste) {
                if(caste == null || caste == Caste.sansCaste) {
                  setState(() {
                    widget.character.honoraryCaste = null;
                  });
                  return;
                }
                setState(() {
                  widget.character.honoraryCaste ??= CharacterCaste.empty();
                  widget.character.honoraryCaste?.caste = caste;
                });
              },
              dropdownMenuEntries: Caste.values
                .map((Caste caste) => DropdownMenuEntry(value: caste, label: caste.title))
                .toList(),
            ),
            if(widget.character.honoraryCaste != null)
              ValueListenableBuilder(
                valueListenable: widget.character.honoraryCaste!.casteNotifier,
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
                    initialSelection: widget.character.honoraryCaste!.status,
                    onSelected: (CasteStatus? status) {
                      if(status == null) return;
                      widget.character.honoraryCaste!.status = status;
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