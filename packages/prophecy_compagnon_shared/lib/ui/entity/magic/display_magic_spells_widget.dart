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
import 'package:prophecy_compagnon_shared/classes/magic.dart';
import 'package:prophecy_compagnon_shared/classes/magic_user.dart';
import 'package:prophecy_compagnon_shared/ui/entity/magic/display_sphere_magic_spells_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDisplayMagicSpellsWidget extends StatelessWidget {
  const EntityDisplayMagicSpellsWidget({ super.key, required this.entity });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var spellWidgets = <Widget>[];
    for(var sphere in MagicSphere.values) {
      var s = entity.magic.spells.forSphere(sphere);
      if(s.isNotEmpty) {
        spellWidgets.add(
          DisplaySphereMagicSpellsWidget(
            sphere: sphere,
            spells: s.toList(),
          )
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Sorts connus',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 8.0,
        children: spellWidgets,
      )
    );
  }
}