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
import 'package:prophecy_compagnon_shared/ui/entity/magic/magic_sphere_edit_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditMagicSpheresWidget extends StatelessWidget {
  const EntityEditMagicSpheresWidget({
    super.key,
    required this.entity,
  });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Sphères',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for(var i=0; i<3; ++i)
            Row(
              children: [
                for(var j=0; j<3; ++j)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: MagicSphereEditWidget(
                        sphere: MagicSphere.values[j+i*3],
                        value: entity.magic.spheres.get(MagicSphere.values[j+i*3]),
                        pool: entity.magic.pools.get(MagicSphere.values[j+i*3]),
                        onValueChanged: (int value) {
                          entity.magic.spheres.set(MagicSphere.values[j+i*3], value);
                        },
                        onPoolChanged: (int value) {
                          entity.magic.pools.set(MagicSphere.values[j+i*3], value);
                        },
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}