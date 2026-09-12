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
import 'package:prophecy_compagnon_shared/classes/caste/career.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterViewCasteBenefitsWidget extends StatelessWidget {
  const CharacterViewCasteBenefitsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Bénéfices de Caste',
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
              return _CasteBenefitsWidget(character: character);
            }
          );
        }
      )
    );
  }
}

class _CasteBenefitsWidget extends StatelessWidget {
  const _CasteBenefitsWidget({ required this.character });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widgets = <Widget>[];

    for(var b in Caste.benefits(character.caste.caste, character.caste.status)) {
      widgets.add(_CasteBenefitWidget(benefit: b));
    }

      widgets.add(
        ValueListenableBuilder(
          valueListenable: character.caste.careerNotifier,
          builder: (BuildContext context, Career? career, _) {
            if(career == null) {
              return SizedBox.shrink();
            }
            else {
              return _CasteBenefitWidget(
                benefit:
                  'Bénéfice de carrière : ${career.benefit.title}'
                  '\n${career.benefit.description}'
              );
            }
          }
        )
      );

    if(widgets.isEmpty) {
      widgets.add(
          SizedBox(
            width: double.infinity,
            child: Text(
              'Pas de bénéfices',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
              softWrap: true,
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

class _CasteBenefitWidget extends StatelessWidget {
  const _CasteBenefitWidget({ required this.benefit });

  final String benefit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit,
                  style: theme.textTheme.bodySmall,
                  softWrap: true,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}