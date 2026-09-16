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

import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base_skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_matcher.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill_family.dart';

class SkillFamilyDiceThrowMatcher extends DiceThrowMatcher {
  SkillFamilyDiceThrowMatcher({ required this.family });

  SkillFamily family;

  @override
  bool matches(DiceThrowRequest request) {
    if(request.base is! DiceThrowEntityBaseSkill) return false;
    return (request.base as DiceThrowEntityBaseSkill).skill?.family == family;
  }
}