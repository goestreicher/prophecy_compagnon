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
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';

class ToggleEquipmentStorageWidget extends StatefulWidget {
  const ToggleEquipmentStorageWidget({
    super.key,
    required this.entity,
    required this.equipment,
    this.carriedWidget,
  });

  final EntityBase entity;
  final Equipment equipment;
  final Widget? carriedWidget;

  @override
  State<ToggleEquipmentStorageWidget> createState() => _ToggleEquipmentStorageWidgetState();
}

class _ToggleEquipmentStorageWidgetState extends State<ToggleEquipmentStorageWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(widget.carriedWidget != null && !widget.equipment.inStore)
          widget.carriedWidget!,
        Column(
          children: [
            Switch(
              value: !widget.equipment.inStore,
              onChanged: (bool value) {
                setState(() {
                  if(value) {
                    widget.entity.unstoreEquipment(widget.equipment);
                  }
                  else {
                    widget.entity.storeEquipment(widget.equipment);
                  }
                });
              },
            ),
            Text(
              widget.equipment.inStore
                ? 'Stocké'
                : 'Porté',
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
      ],
    );
  }
}