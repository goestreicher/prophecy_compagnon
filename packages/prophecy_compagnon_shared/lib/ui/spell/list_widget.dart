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
import 'package:prophecy_compagnon_shared/classes/magic_spell.dart';

class SpellsListWidget extends StatelessWidget {
  const SpellsListWidget({
    super.key,
    required this.spells,
    this.selected,
    required this.onSelected,
  });

  final List<MagicSpell> spells;
  final String? selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var spellsWidgets = <Widget>[];

    for(var i = 1; i <= 3; ++i) {
      var s = spells.where((MagicSpell spell) => spell.level == i);

      if(s.isNotEmpty) {
        spellsWidgets.add(
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Niveau $i',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          )
        );

        spellsWidgets.addAll(
          s.map(
            (MagicSpell spell) => Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              color: selected == spell.id ?
              theme.colorScheme.surfaceContainerHighest :
              null,
              child: InkWell(
                onTap: () {
                  onSelected(spell.id);
                },
                child: ListTile(
                  title: Text(
                    spell.name,
                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            )
          )
        );
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: spellsWidgets,
        )
      )
    );
  }
}