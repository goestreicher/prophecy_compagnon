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
import 'package:prophecy_compagnon_shared/classes/equipment/misc_gear.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/equipment_info_widgets.dart';
import 'package:prophecy_compagnon_shared/ui/entity/equipment/toggle_equipment_storage_widget.dart';

class MiscGearManageWidget extends StatelessWidget {
  const MiscGearManageWidget({
    super.key,
    required this.entity,
    required this.item,
    required this.quantity,
    this.onRemoved,
    this.onDecreased,
    this.onIncreased,
  });

  final EntityBase entity;
  final MiscGear item;
  final int quantity;
  final void Function()? onRemoved;
  final void Function()? onDecreased;
  final void Function()? onIncreased;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var leading = <Widget>[];
    if(onRemoved != null) {
      leading.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onRemoved!(),
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
            MiscGearInfoWidget(item: item),
            const Spacer(),
            Column(
              spacing: 4.0,
              children: [
                Row(
                  spacing: 8.0,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: onDecreased == null || quantity < 2
                        ? null
                        : () => onDecreased!.call(),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 18.0,
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(),
                      onPressed: onIncreased == null
                        ? null
                        : () => onIncreased!.call(),
                    ),
                  ]
                ),
                Text(
                  'Quantité',
                  style: theme.textTheme.bodySmall,
                )
              ],
            ),
            ToggleEquipmentStorageWidget(
              entity: entity,
              equipment: item,
            ),
          ],
        ),
      ),
    );
  }
}