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
import 'package:prophecy_compagnon_shared/classes/magic.dart';
import 'package:prophecy_compagnon_shared/classes/magic_user.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/single_skill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDisplayMagicSkillsWidget extends StatelessWidget {
  const EntityDisplayMagicSkillsWidget({ super.key, required this.entity });

  final MagicUser entity;

  @override
  Widget build(BuildContext context) {
    return WidgetGroupContainer(
      child: Column(
        spacing: 12.0,
        children: [
          SingleSkillWidget(
            name: 'Instinctive',
            value: entity.magic.skills.get(MagicSkill.instinctive),
          ),
          SingleSkillWidget(
            name: 'Invocatoire',
            value: entity.magic.skills.get(MagicSkill.invocatoire),
          ),
          SingleSkillWidget(
            name: 'Sorcellerie',
            value: entity.magic.skills.get(MagicSkill.sorcellerie),
          ),
          SingleSkillWidget(
            name: 'Réserve',
            value: entity.magicPool,
          ),
        ]
      )
    );
  }
}