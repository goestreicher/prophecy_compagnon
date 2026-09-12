/*
 * Copyright (C) 2026 Grégory Oestreicher
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
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/edit_skill_group_container.dart';

class CharacterEditSkillsWidget extends StatelessWidget {
  const CharacterEditSkillsWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 12.0,
      children: [
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.physique,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.mental,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.manuel,
        ),
        EntityEditSkillGroupContainer(
          entity: character,
          attribute: Attribute.social,
        ),
      ],
    );
  }
}