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
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CreatureDisplaySecondaryAttributes extends StatelessWidget {
  const CreatureDisplaySecondaryAttributes({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var armorValue = '${creature.naturalArmor.toString()}${creature.naturalArmorDescription.isEmpty ? "" : " (${creature.naturalArmorDescription})"}';

    return WidgetGroupContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8.0,
        children: [
          _SecondaryAttributeEntryWidget(
            title: 'Initiative',
            value: creature.initiative.toString()
          ),
          _SecondaryAttributeEntryWidget(
            title: 'Armure naturelle',
            value: armorValue,
          ),
        ],
      )
    );
  }
}

class _SecondaryAttributeEntryWidget extends StatelessWidget {
  const _SecondaryAttributeEntryWidget({ required this.title, required this.value });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodyMedium,
          )
        ]
      )
    );
  }
}