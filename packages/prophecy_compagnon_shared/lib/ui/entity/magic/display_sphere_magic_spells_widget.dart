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
import 'package:prophecy_compagnon_shared/classes/magic.dart';
import 'package:prophecy_compagnon_shared/classes/magic_spell.dart';
import 'package:prophecy_compagnon_shared/ui/entity/magic/display_magic_spell_widget.dart';

class DisplaySphereMagicSpellsWidget extends StatelessWidget {
  const DisplaySphereMagicSpellsWidget({
    super.key,
    required this.sphere,
    required this.spells,
    this.onDelete,
  });

  final MagicSphere sphere;
  final List<MagicSpell> spells;
  final void Function(String)? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.0,
          children: [
            SizedBox(
              width: 32,
              height: 48,
              child: Image.asset(
                'packages/prophecy_compagnon_shared/assets/images/magic/sphere-${sphere.name}-icon.png',
              ),
            ),
            Text(
              sphere.title,
              style: theme.textTheme.bodySmall,
            )
          ],
        ),
        for(var spell in spells)
          DisplayMagicSpellWidget(
            spell: spell,
            onDelete: onDelete == null ? null : () => onDelete?.call(spell.name),
          )
      ],
    );
  }
}