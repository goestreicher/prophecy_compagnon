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
import 'package:prophecy_compagnon_shared/classes/caste/base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/dismissible_dialog.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterViewCasteTechniquesWidget extends StatelessWidget {
  const CharacterViewCasteTechniquesWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Techniques de Caste',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: character.caste.casteNotifier,
        builder: (BuildContext context, Caste value, _) {
          return ValueListenableBuilder(
            valueListenable: character.caste.statusNotifier,
            builder: (BuildContext context, CasteStatus status, _) {
              return _CasteTechniquesWidget(character: character);
            }
          );
        }
      )
    );
  }
}

class _CasteTechniquesWidget extends StatelessWidget {
  const _CasteTechniquesWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var widgets = <Widget>[];

    for(var t in Caste.techniques(character.caste.caste, character.caste.status)) {
      widgets.add(_CasteTechniqueWidget(technique: t.title, description: t.description,));
    }

    if(widgets.isEmpty) {
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: Text(
            'Pas de techniques',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        )
      );
    }

    return Column(
      spacing: 12.0,
      children: widgets,
    );
  }
}

class _CasteTechniqueWidget extends StatelessWidget {
  const _CasteTechniqueWidget({ required this.technique, this.description });

  final String technique;
  final String? description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
                ),
              ],
            ),
          ),
          if(description != null && description!.isNotEmpty)
            IconButton(
              style: IconButton.styleFrom(
                iconSize: 16.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.info_outlined),
              onPressed: () {
                Navigator.of(context).push(
                  DismissibleDialog<void>(
                    title: technique,
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400,
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          description!,
                        ),
                      )
                    )
                  )
                );
              },
            ),
        ],
      ),
    );
  }
}