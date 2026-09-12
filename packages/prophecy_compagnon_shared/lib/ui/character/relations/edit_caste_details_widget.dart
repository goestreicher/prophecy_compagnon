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
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/edit_caste_career_widget.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/edit_caste_interdicts_widget.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/edit_caste_privileges_widget.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/edit_honorary_caste_widget.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/view_caste_benefits_widget.dart';
import 'package:prophecy_compagnon_shared/ui/character/relations/view_caste_techniques_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class CharacterEditCasteDetailsWidget extends StatelessWidget {
  const CharacterEditCasteDetailsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Caste',
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 16.0,
        children: [
          CharacterEditCasteCareerWidget(
            character: character,
          ),
          CharacterEditHonoraryCasteWidget(
            character: character,
          ),
          CharacterEditCasteInterdictsWidget(
            character: character,
          ),
          CharacterEditCastePrivilegesWidget(
            character: character,
          ),
          CharacterViewCasteTechniquesWidget(
            character: character,
          ),
          CharacterViewCasteBenefitsWidget(
            character: character,
          ),
        ],
      ),
    );
  }
}