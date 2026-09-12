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
import 'package:prophecy_compagnon_shared/ui/creature/base/display_natural_weapon_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CreatureDisplayNaturalWeaponsWidget extends StatelessWidget {
  const CreatureDisplayNaturalWeaponsWidget({ super.key, required this.creature });

  final Creature creature;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];
    if(creature.naturalWeapons.isEmpty) {
      widgets.add(Text(
        'Aucune',
        style: theme.textTheme.bodySmall!.copyWith(
          fontStyle: FontStyle.italic
        ),
      ));
    }
    else {
      for(var w in creature.naturalWeapons) {
        widgets.add(
          NaturalWeaponDisplayWidget(
            weapon: w,
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armes naturelles',
        style: theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: widgets,
      )
    );
  }
}