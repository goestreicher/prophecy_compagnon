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
import 'package:prophecy_compagnon_shared/ui/entity/base/display_draconic_favor_widget.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/draconic_favor_picker_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/uniform_height_wrap.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDisplayDraconicFavorsWidget extends StatelessWidget {
  const EntityDisplayDraconicFavorsWidget({
    super.key,
    required this.entity,
    this.edit = false,
  });

  final EntityBase entity;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Faveurs draconiques',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Center(
        child: Column(
          spacing: 12.0,
          children: [
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: ListenableBuilder(
                listenable: entity.favors,
                builder: (BuildContext context, _) {
                  return UniformHeightWrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: [
                      for(var favor in entity.favors)
                        DisplayDraconicFavorWidget(
                          favor: favor,
                          onDelete: !edit
                            ? null
                            : () {
                              entity.favors.remove(favor);
                            },
                        ),
                    ],
                  );
              },
              ),
            ),
            if(edit)
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 16.0,
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: theme.textTheme.bodySmall,
                ),
                label: const Text('Nouvelle faveur'),
                onPressed: () async {
                  var favor = await showDialog(
                    context: context,
                    builder: (BuildContext context) => DraconicFavorPickerDialog(),
                  );
                  if(!context.mounted) return;
                  if(favor == null) return;

                  entity.favors.add(favor);
                },
              ),
          ],
        ),
      )
    );
  }
}