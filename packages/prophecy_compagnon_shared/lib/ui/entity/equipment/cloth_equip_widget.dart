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
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/cloth.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/equipment_info_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/toggle_equipment_storage_widget.dart';

class ClothEquipWidget extends StatelessWidget {
  const ClothEquipWidget({
    super.key,
    required this.entity,
    required this.cloth,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Cloth cloth;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var leading = <Widget>[];
    if(allowDelete) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            entity.unequip(cloth);
            entity.equipment.remove(cloth);
          },
        )
      );
    }

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8.0,
          children: [
            ...leading,
            ClothInfoWidget(cloth: cloth),
            const Spacer(),
            ToggleEquipmentStorageWidget(
              entity: entity,
              equipment: cloth,
              carriedWidget: Column(
                children: [
                  Switch(
                    value: entity.isEquiped(cloth),
                    onChanged: (bool value) {
                      if(value) {
                        entity.replaceEquiped(
                          item: cloth,
                          target: (cloth.model as EquipableItemModel).slot,
                        );
                      }
                      else if(!value && entity.isEquiped(cloth)) {
                        entity.unequip(cloth);
                      }
                    },
                  ),
                  Text(
                    entity.isEquiped(cloth) ? 'Déséquiper' : 'Équiper',
                    style: theme.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}