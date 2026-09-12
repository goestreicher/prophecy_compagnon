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
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/fervor/display_spirit_power_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterDisplayFervorWidget extends StatelessWidget {
  const CharacterDisplayFervorWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.0,
      children: [
        WidgetGroupContainer(
          child: SizedBox(
            width: 150,
            child: Row(
              spacing: 16.0,
              children: [
                Expanded(child: Text('Ferveur')),
                Text(character.fervor.value.toString()),
              ],
            ),
          ),
        ),
        Expanded(
          child: WidgetGroupContainer(
            child: Center(
              child: Column(
                spacing: 16.0,
                children: [
                  if(character.fervor.powers.isEmpty)
                    Center(
                      child: Text("Aucun pouvoir de l'esprit")
                    ),
                  for(var power in character.fervor.powers)
                    DisplaySpiritPowerWidget(
                      power: power,
                    ),
                ],
              ),
            )
          )
        ),
      ],
    );
  }
}