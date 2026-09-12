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
import 'package:prophecy_compagnon_shared/classes/place.dart';
import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterDisplayGeneralWidget extends StatelessWidget {
  const CharacterDisplayGeneralWidget({ super.key, required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          if(character is PlayerCharacter)
            Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: _GeneralWidgetHeader(title: 'Joueur', value: (character as PlayerCharacter).player),
                ),
                Expanded(
                    child: _GeneralWidgetHeader(title: 'Augure', value: (character as PlayerCharacter).augure.title)
                ),
              ],
            ),
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _GeneralWidgetHeader(title: 'Nom', value: character.name),
              ),
              Expanded(
                child: FutureBuilder(
                  future: character.origin.place,
                  builder: (BuildContext context, AsyncSnapshot<Place?> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return _GeneralWidgetHeader(
                        title: 'Origine',
                        value: 'Chargement...',
                      );
                    }

                    if(!snapshot.hasData || snapshot.data == null) {
                      return _GeneralWidgetHeader(
                        title: 'Origine',
                        value: 'Erreur de chargement',
                      );
                    }

                    var place = snapshot.data!;
                    return _GeneralWidgetHeader(
                      title: 'Origine',
                      value: place.name
                    );
                  }
                )
              ),
            ],
          ),
          Row(
            spacing: 16.0,
            children: [
              Expanded(
                child: _GeneralWidgetHeader(title: 'Caste', value: character.caste.caste.title)
              ),
              Expanded(
                child: _GeneralWidgetHeader(title: 'Statut', value: Caste.statusName(character.caste.caste, character.caste.status))
              ),
              Expanded(
                child: _GeneralWidgetHeader(
                  title: 'Carrière',
                  value: character.caste.career == null
                    ? 'Aucune'
                    : character.caste.career!.title
                )
              ),
            ],
          ),
          if(character.honoraryCaste != null)
            Row(
              spacing: 16.0,
              children: [
                Flexible(
                  child: _GeneralWidgetHeader(
                    title: 'Caste Honoraire',
                    value: character.honoraryCaste!.caste.title
                  )
                ),
                Flexible(
                  child: _GeneralWidgetHeader(
                    title: 'Statut Honoraire',
                    value: Caste.statusName(character.honoraryCaste!.caste, character.honoraryCaste!.status)
                  )
                ),
              ],
            ),
          Row(
            spacing: 16.0,
            children: [
              _GeneralWidgetHeader(title: 'Âge', value: character.age.toString()),
              _GeneralWidgetHeader(title: 'Taille (m)', value: character.height.toStringAsFixed(2)),
              _GeneralWidgetHeader(title: 'Poids (kg)', value: character.weight.toStringAsFixed(0)),
            ],
          )
        ],
      )
    );
  }
}

class _GeneralWidgetHeader extends StatelessWidget {
  const _GeneralWidgetHeader({ required this.title, required this.value });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: theme.textTheme.bodyMedium,
          )
        ]
      )
    );
  }
}