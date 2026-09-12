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
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CreatureEditSecondaryAttributes extends StatefulWidget {
  const CreatureEditSecondaryAttributes({ super.key, required this.creature });

  final Creature creature;

  @override
  State<CreatureEditSecondaryAttributes> createState() => _CreatureEditSecondaryAttributesState();
}

class _CreatureEditSecondaryAttributesState extends State<CreatureEditSecondaryAttributes> {
  final TextEditingController naturalArmorDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: NumIntInputWidget(
                  initialValue: widget.creature.initiative,
                  maxValue: 10,
                  onChanged: (int value) {
                    widget.creature.initiative = value;
                  },
                  label: 'INItiative',
                ),
              ),
              Expanded(
                child: NumIntInputWidget(
                  initialValue: widget.creature.naturalArmor,
                  minValue: 0,
                  maxValue: 999,
                  onChanged: (int value) {
                    widget.creature.naturalArmor = value;
                  },
                  label: 'Armure',
                ),
              ),
            ],
          ),
          TextFormField(
            controller: naturalArmorDescriptionController,
            decoration: const InputDecoration(
              label: Text('Armure naturelle (description)'),
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.all(12.0),
            ),
            style: theme.textTheme.bodySmall,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (String? value) => widget.creature.naturalArmorDescription = naturalArmorDescriptionController.text,
          ),
        ],
      ),
    );
  }
}