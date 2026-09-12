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
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';

class AbilityListEditWidget extends StatelessWidget {
  const AbilityListEditWidget({
    super.key,
    required this.abilities,
    this.minValue = 1,
    this.maxValue = 15,
    required this.onChanged,
    this.onSaved,
  });

  final Map<Ability, int> abilities;
  final int minValue;
  final int maxValue;
  final void Function(Ability, int) onChanged;
  final void Function(Ability, int)? onSaved;

  @override
  Widget build(BuildContext context) {
    var widgetRows = <Widget>[];

    for(var i = 0; (i+4) < Ability.values.length; ++i) {
      var currentRow = <Widget>[
        Expanded(
          child: NumIntInputWidget(
            initialValue: abilities[Ability.values[i]] ?? 0,
            minValue: minValue,
            maxValue: maxValue,
            onChanged: (int value) {
              onChanged(Ability.values[i], value);
            },
            onSaved: (int value) {
              onSaved?.call(Ability.values[i], value);
            },
            label: '${Ability.values[i].title.substring(0, 3).toUpperCase()}${Ability.values[i].title.substring(3)}',
          ),
        ),
      ];

      if(i + 4 < Ability.values.length) {
        currentRow.add(
          Expanded(
            child: NumIntInputWidget(
              initialValue: abilities[Ability.values[i+4]] ?? 0,
              minValue: minValue,
              maxValue: maxValue,
              onChanged: (int value) {
                onChanged(Ability.values[i+4], value);
              },
              onSaved: (int value) {
                onSaved?.call(Ability.values[i+4], value);
              },
              label: '${Ability.values[i+4].title.substring(0, 3).toUpperCase()}${Ability.values[i+4].title.substring(3)}',
            ),
          ),
        );
      }

      widgetRows.add(
        Row(
          spacing: 8.0,
          children: [
            ...currentRow,
          ],
        )
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgetRows
      ],
    );
  }
}