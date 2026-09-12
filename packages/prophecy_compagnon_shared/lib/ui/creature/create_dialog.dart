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
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/creature/create_form.dart';

class CreatureCreateDialog extends StatelessWidget {
  const CreatureCreateDialog({ super.key, required this.source, this.cloneFrom });

  final ObjectSource source;
  final Creature? cloneFrom;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle créature'),
      content: CreatureCreateForm(
        source: source,
        cloneFrom: cloneFrom,
        onCreatureCreated: (Creature? c) {
          Navigator.of(context, rootNavigator: true).pop(c);
        },
      ),
    );
  }
}