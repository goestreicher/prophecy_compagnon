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

import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/num_input_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditMoneyWidget extends StatelessWidget {
  const EntityEditMoneyWidget({
    super.key,
    required this.entity
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Argent',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Dragons"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.dragon,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.dragon = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Or"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.or,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.or = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Argent"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.argent,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.argent = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Bronze"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.bronze,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.bronze = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Fer"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.fer,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.fer = v,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}