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
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_instance.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/single_skill_widget.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityDisplaySkillFamilyWidget extends StatelessWidget {
  const EntityDisplaySkillFamilyWidget({
    super.key,
    required this.entity,
    required this.family,
  });

  final EntityBase entity;
  final SkillFamily family;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var skillWidgets = <Widget>[];

    for(var skill in entity.skills.forFamily(family)) {
      skillWidgets.add(
        SkillDisplayWidget(skill: skill),
      );
    }

    return WidgetGroupContainer(
      title: Text(
        family.title,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Align(
        alignment: AlignmentGeometry.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8.0,
          children: [
            ...skillWidgets,
          ],
        ),
      )
    );
  }
}

class SkillDisplayWidget extends StatelessWidget {
  const SkillDisplayWidget({
    super.key,
    required this.skill
  });

  final SkillInstance skill;

  @override
  Widget build(BuildContext context) {
    var skillWidget = SingleSkillWidget(
      name: skill.title,
      value: skill.value,
      description: skill.skill.description,
    );

    var specializedSkills = <Widget>[];
    for(var sp in skill.specializations) {
      specializedSkills.add(
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SingleSkillWidget(
            name: sp.skill.name,
            value: sp.value,
            description: sp.skill.description,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        skillWidget,
        ...specializedSkills,
      ],
    );
  }
}