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
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/ui/creature/create_widget.dart';

class CreatureClonePage extends StatelessWidget {
  const CreatureClonePage({ super.key, required this.from });

  final String from;

  @override
  Widget build(BuildContext context) {
    return CreatureCreateWidget(
      cloneFrom: from,
      onCreatureCreated: (Creature? creature) {
        if(creature == null) {
          context.go('/creatures');
        }
        else {
          context.go('/creatures/${creature.id}');
        }
      },
    );
  }
}