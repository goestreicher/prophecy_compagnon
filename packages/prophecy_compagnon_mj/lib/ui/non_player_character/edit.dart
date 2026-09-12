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
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/edit_widget.dart';

class NPCEditPage extends StatelessWidget {
  const NPCEditPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NonPlayerCharacter.get(id),
      builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }

        if(!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text('PNJ non trouvé'),
          );
        }

        var npc = snapshot.data!;

        return CharacterEditWidget(
          character: npc,
          onEditDone: (bool result) async {
            if(result) {
              await NonPlayerCharacter.saveLocalModel(npc);
              if(!context.mounted) return;
              context.go('/npcs/${npc.id}');
            }
            else {
              await NonPlayerCharacter.reloadFromStore(id);
              if(!context.mounted) return;
              context.go('/npcs/${npc.id}');
            }
          }
        );
      }
    );
  }
}