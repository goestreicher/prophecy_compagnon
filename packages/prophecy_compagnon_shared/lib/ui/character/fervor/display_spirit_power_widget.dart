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
import 'package:prophecy_compagnon_shared/classes/entity/spirit_powers.dart';

class DisplaySpiritPowerWidget extends StatelessWidget {
  const DisplaySpiritPowerWidget({
    super.key,
    required this.power,
    this.onDelete,
  });

  final SpiritPower power;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                Text(
                  '${power.title} (${power.cost})',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  power.description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if(onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                onPressed: () {
                  onDelete?.call();
                },
                style: IconButton.styleFrom(
                  iconSize: 16.0,
                ),
                icon: const Icon(Icons.delete),
              ),
            )
        ],
      )
    );
  }
}