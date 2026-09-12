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
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/equipment/list_filter.dart';
import 'package:prophecy_compagnon_shared/ui/equipment/list_widget.dart';

class ScenarioEditEquipmentPage extends StatelessWidget {
  const ScenarioEditEquipmentPage({
    super.key,
    required this.scenarioSource,
    required this.onEquipmentCreated,
    required this.onEquipmentModified,
    required this.onEquipmentDeleted,
  });

  final ObjectSource scenarioSource;
  final void Function(EquipmentModel) onEquipmentCreated;
  final void Function(EquipmentModel) onEquipmentModified;
  final void Function(EquipmentModel) onEquipmentDeleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EquipmentListWidget(
        source: scenarioSource,
        filter: EquipmentModelListFilter(
          source: scenarioSource,
        ),
        onEquipmentCreated: onEquipmentCreated,
        onEquipmentModified: onEquipmentModified,
        onEquipmentDeleted: onEquipmentDeleted,
      ),
    );
  }
}