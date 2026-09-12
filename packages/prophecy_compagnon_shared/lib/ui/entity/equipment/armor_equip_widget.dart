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
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/equipment_info_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/toggle_equipment_storage_widget.dart';

class ArmorEquipWidget extends StatelessWidget {
  const ArmorEquipWidget({
    super.key,
    required this.entity,
    required this.armor,
    this.allowDelete = true,
  });

  final EntityBase entity;
  final Armor armor;
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
            entity.unequip(armor);
            entity.equipment.remove(armor);
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
            ArmorInfoWidget(armor: armor),
            const Spacer(),
            ToggleEquipmentStorageWidget(
              entity: entity,
              equipment: armor,
              carriedWidget: Row(
                spacing: 8.0,
                children: [
                  if(!entity.meetsEquipableRequirements(armor))
                    Text(
                      'Pré-requis\n${entity.unmetEquipableRequirementsDescription(armor)}',
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodySmall,
                    ),
                  Column(
                    children: [
                      Switch(
                        value: entity.isEquiped(armor),
                        onChanged: !entity.meetsEquipableRequirements(armor)
                            ? null
                            : (bool value) {
                          if(value) {
                            entity.replaceEquiped(
                              item: armor,
                              target: (armor.model as EquipableItemModel).slot,
                            );
                          }
                          else if(!value && entity.isEquiped(armor)) {
                            entity.unequip(armor);
                          }
                        },
                      ),
                      Text(
                        entity.isEquiped(armor) ? 'Déséquiper' : 'Équiper',
                        style: theme.textTheme.bodySmall,
                      )
                    ],
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}