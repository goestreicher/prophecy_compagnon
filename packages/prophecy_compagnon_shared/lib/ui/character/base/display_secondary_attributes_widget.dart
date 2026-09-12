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
import 'package:prophecy_compagnon_shared/ui/entity/base/attribute_display_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterDisplaySecondaryAttributesWidget extends StatelessWidget {
  const CharacterDisplaySecondaryAttributesWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: Column(
              spacing: 8.0,
              children: [
                AttributeDisplayWidget(name: 'INI', value: character.initiative),
                AttributeDisplayWidget(name: 'CHA', value: character.luck),
                AttributeDisplayWidget(name: 'MAÎ', value: character.proficiency),
                AttributeDisplayWidget(name: 'REN', value: character.renown),
              ],
            ),
          ),
        ],
      )
    );
  }
}