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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';
import 'package:prophecy_compagnon_shared/classes/entity/skill.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill.dart';

class SkillThrowWrapperToBaseArgs {
  SkillThrowWrapperToBaseArgs({
    required this.attribute,
    this.fallbackAbility,
  });

  Attribute attribute;
  Ability? fallbackAbility;
}

abstract class SkillThrowWrapper {
  SkillThrowWrapper();

  DiceThrowEntityBase toBase(SkillThrowWrapperToBaseArgs args);
}

class SeparatorSkillThrowWrapper extends SkillThrowWrapper {
  SeparatorSkillThrowWrapper();

  @override
  DiceThrowEntityBase toBase(SkillThrowWrapperToBaseArgs args) {
    throw UnimplementedError();
  }
}

class StandardSkillThrowWrapper extends SkillThrowWrapper {
  StandardSkillThrowWrapper({
    required this.skill,
    this.implementation,
  });

  final Skill skill;
  final String? implementation;

  @override
  DiceThrowEntityBase toBase(SkillThrowWrapperToBaseArgs args) => DiceThrowEntityBaseSkill(
    attribute: args.attribute,
    skill: skill,
    implementation: implementation,
    ability: args.fallbackAbility,
  );
}

class SpecializationSkillThrowWrapper extends SkillThrowWrapper {
  SpecializationSkillThrowWrapper({
    required this.specialization,
  });

  final SpecializedSkill specialization;

  @override
  DiceThrowEntityBase toBase(SkillThrowWrapperToBaseArgs args) => DiceThrowEntityBaseSkill(
    attribute: args.attribute,
    specialization: specialization,
    implementation: specialization.parentImplementation,
    ability: args.fallbackAbility,
  );
}