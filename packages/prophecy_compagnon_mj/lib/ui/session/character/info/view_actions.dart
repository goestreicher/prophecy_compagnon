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
import 'package:prophecy_compagnon_mj/ui/session/character/menus/ability_throw_menu.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/dice_throw_menu.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/effects_menu.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/shared_dice_throw_items.dart';
import 'package:prophecy_compagnon_mj/ui/session/character/menus/skill_throw_menu.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class SessionCharacterInfoViewActions extends StatelessWidget {
  const SessionCharacterInfoViewActions({
    super.key,
    required this.character,
  });

  final EntityBase character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text('Actions'),
      titleBackgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          DiceThrowMenuWidget(
            label: 'Jets communs',
            entities: [character],
            items: [
              ...sharedDiceThrowItems['perception']!,
              ...sharedDiceThrowItems['discretion']!,
              ...sharedDiceThrowItems['luck']!,
            ],
          ),
          SkillThrowMenuWidget(
            entity: character,
          ),
          AbilityThrowMenuWidget(
            entities: [character],
          ),
          if(character.effects.isNotEmpty)
            EffectsMenuWidget(
              entity: character,
            ),
        ],
      )
    );
  }
}