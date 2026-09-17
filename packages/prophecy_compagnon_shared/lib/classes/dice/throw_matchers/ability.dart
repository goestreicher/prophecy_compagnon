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

import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/ability.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_matcher.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';

class AbilityDiceThrowMatcher extends DiceThrowMatcher {
  const AbilityDiceThrowMatcher({ required this.ability });

  final Ability ability;

  @override
  bool matches(DiceThrowRequest request) =>
      (
        request.base is DiceThrowEntityBaseAbility
        && (request.base as DiceThrowEntityBaseAbility).ability == ability
      )
      ||
      (
        request.base is DiceThrowEntityBaseSkill
        && (request.base as DiceThrowEntityBaseSkill).ability == ability
      );
}