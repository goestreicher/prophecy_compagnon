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
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/armor.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/equipment_info_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class DisplayArmorWidget extends StatelessWidget {
  const DisplayArmorWidget({
    super.key,
    required this.entity
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var eq in entity.equipment) {
      if (eq is Armor) {
        widgets.add(
          _DisplayContainerWidget(
            content: ArmorInfoWidget(armor: eq)
          ),
        );
      }
    }

    return WidgetGroupContainer(
      title: Text(
        'Armure',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        )
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: Wrap(
          spacing: 12.0,
          runSpacing: 8.0,
          children: widgets,
        ),
      ),
    );
  }
}

class _DisplayContainerWidget extends StatelessWidget {
  const _DisplayContainerWidget({ required this.content });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: content,
      )
    );
  }
}