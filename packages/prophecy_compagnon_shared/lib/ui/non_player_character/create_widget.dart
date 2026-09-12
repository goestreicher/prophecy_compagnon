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
import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/ui/character/edit_widget.dart';
import 'package:prophecy_compagnon_shared/ui/non_player_character/create_form.dart';

class NPCCreateWidget extends StatefulWidget {
  const NPCCreateWidget({
    super.key,
    required this.onNPCCreated,
    this.source,
    this.cloneFrom
  });

  final void Function(NonPlayerCharacter?) onNPCCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<NPCCreateWidget> createState() => _NPCCreateWidgetState();
}

class _NPCCreateWidgetState extends State<NPCCreateWidget> {
  NonPlayerCharacter? from;
  NonPlayerCharacter? npc;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: NonPlayerCharacter.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<NonPlayerCharacter?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('PNJ source non trouvé'),
            );
          }

          from = snapshot.data!;
          return getNPCCreateForm();
        }
      );
    }

    if(npc == null) {
      return getNPCCreateForm();
    }

    return CharacterEditWidget(
      character: npc!,
      onEditDone: (bool result) async {
        if(result) {
          await NonPlayerCharacter.saveLocalModel(npc!);
        }
        else {
          NonPlayerCharacter.removeFromCache(npc!.id);
          npc = null;
        }

        widget.onNPCCreated(npc);
      }
    );
  }

  Widget getNPCCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: NPCCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onNPCCreated: (NonPlayerCharacter? n) {
              if(n == null) {
                widget.onNPCCreated(null);
              }
              else {
                setState(() {
                  npc = n;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}