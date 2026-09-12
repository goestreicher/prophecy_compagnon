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
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/entity/base/edit_skill_family_container.dart';
import 'package:prophecy_compagnon_shared/ui/widget_group_container.dart';

class EntityEditSkillGroupContainer extends StatelessWidget {
  const EntityEditSkillGroupContainer({
    super.key,
    required this.entity,
    required this.attribute,
  });

  final EntityBase entity;
  final Attribute attribute;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var familyWidgets = SkillFamily.values
      .where((SkillFamily f) => f.defaultAttribute == attribute)
      .map(
        (SkillFamily f) => ListenableBuilder(
          listenable: entity.skills.families[f]!,
          builder: (BuildContext context, _) {
            return EntityEditSkillFamilyContainer(
              entity: entity,
              family: f,
            );
          }
        )
      ).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 450,
      ),
      child: WidgetGroupContainer(
        title: StreamBuilder<AttributeStreamChange>(
          stream: entity.attributes.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<AttributeStreamChange> snapshot) {
            return Text(
              '${attribute.name} : ${entity.attributes.attribute(attribute)}',
              style: theme.textTheme.titleLarge!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )
            );
          }
        ),
        child: Column(
          spacing: 20.0,
          children: familyWidgets,
        )
      ),
    );
  }
}