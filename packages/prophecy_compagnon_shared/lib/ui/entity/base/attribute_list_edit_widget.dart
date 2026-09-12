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

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';

class AttributeListEditWidget extends StatelessWidget {
  const AttributeListEditWidget({
    super.key,
    required this.attributes,
    this.minValue = 1,
    this.maxValue = 15,
    required this.onChanged,
    this.onSaved,
  });

  final Map<Attribute, int> attributes;
  final int minValue;
  final int maxValue;
  final void Function(Attribute, int) onChanged;
  final void Function(Attribute, int)? onSaved;

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    for(var attribute in attributes.keys) {
      widgets.add(
        NumIntInputWidget(
          initialValue: attributes[attribute]!,
          minValue: minValue,
          maxValue: maxValue,
          onChanged: (int value) {
            onChanged(attribute, value);
          },
          onSaved: (int value) {
            onSaved?.call(attribute, value);
          },
          label: '${attribute.title.substring(0, 3).toUpperCase()}${attribute.title.substring(3)}',
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 12.0,
      children: [
        ...widgets
      ],
    );
  }
}