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
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class PlayerCharacterEditExperienceWidget extends StatelessWidget {
  const PlayerCharacterEditExperienceWidget({
    super.key,
    required this.character,
  });
  
  final PlayerCharacter character;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    
    return WidgetGroupContainer(
      title: Text(
          'Expérience',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          )
      ),
      child: Column(
        spacing: 8,
        children: [
          DropdownMenuFormField(
            initialSelection: character.privilegedExperience,
            requestFocusOnTap: true,
            label: const Text('Optique de progression'),
            expandedInsets: EdgeInsets.zero,
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: PlayerCharacterPrivilegedExperience.values
              .map(
                (PlayerCharacterPrivilegedExperience e) =>
                  DropdownMenuEntry(value: e, label: e.title),
              )
              .toList(),
            onSelected: (PlayerCharacterPrivilegedExperience? e) {
              if(e == null) return;
              character.privilegedExperience = e;
            },
            validator: (PlayerCharacterPrivilegedExperience? e) {
              if(e == null) return 'Valeur obligatoire';
              return null;
            },
          ),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: Text(
                  'Expérience',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              SizedBox(
                width: 100,
                child: NumIntInputWidget(
                  initialValue: character.experience,
                  minValue: 0,
                  maxValue: 999,
                  onChanged: (int value) {
                    character.experience = value;
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}