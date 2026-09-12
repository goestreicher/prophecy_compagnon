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
import 'package:prophecy_compagnon_shared/ui/creature/edit_widget.dart';

class CreatureCreateWidget extends StatefulWidget {
  const CreatureCreateWidget({
    super.key,
    required this.onCreatureCreated,
    this.source,
    this.cloneFrom,
  });

  final void Function(Creature?) onCreatureCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<CreatureCreateWidget> createState() => _CreatureCreateWidgetState();
}

class _CreatureCreateWidgetState extends State<CreatureCreateWidget> {
  Creature? from;
  Creature? creature;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: Creature.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<Creature?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Créature source non trouvée'),
            );
          }

          from = snapshot.data!;
          return getCreatureCreateForm();
        }
      );
    }

    if(creature == null) {
      return getCreatureCreateForm();
    }

    return CreatureEditWidget(
      creature: creature!,
      onEditDone: (bool result) async {
        if(result) {
          await Creature.saveLocalModel(creature!);
        }
        else {
          Creature.removeFromCache(creature!.id);
          creature = null;
        }

        widget.onCreatureCreated(creature);
      }
    );
  }

  Widget getCreatureCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: CreatureCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onCreatureCreated: (Creature? c) {
              if(c == null) {
                widget.onCreatureCreated(null);
              }
              else {
                setState(() {
                  creature = c;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}