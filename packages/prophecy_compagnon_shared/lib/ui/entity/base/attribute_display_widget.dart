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

class AttributeDisplayWidget extends StatelessWidget {
  const AttributeDisplayWidget({ super.key, required this.name, required this.value });
  
  final String name;
  final int value;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 8.0,
      children: [
        Text(
          name,
          textAlign: TextAlign.end,
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 24.0,
          width: 36.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}