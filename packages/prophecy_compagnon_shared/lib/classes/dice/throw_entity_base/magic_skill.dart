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

import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/magic.dart';

class DiceThrowEntityBaseMagicSkill extends DiceThrowEntityBase {
  DiceThrowEntityBaseMagicSkill({
    required this.skill,
    required this.sphere,
  });

  final MagicSkill skill;
  final MagicSphere sphere;

  // TODO: override canThrow to return false if the character does not have the skill and sphere?

  @override
  String get label => '${skill.title} + ${sphere.title}';

  @override
  int value(EntityBase entity) => baseValue(entity) + componentValue(entity);

  @override
  String baseLabel(EntityBase entity) => skill.title;

  @override
  int baseValue(EntityBase entity) => entity.magic.skills.get(skill);

  @override
  String componentLabel(EntityBase entity) => sphere.title;

  @override
  int componentValue(EntityBase entity) => entity.magic.spheres.get(sphere);
}