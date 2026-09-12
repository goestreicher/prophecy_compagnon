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

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/entity/specialized_skill.dart';

part 'specialized_skill_instance.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SpecializedSkillInstance {
  SpecializedSkillInstance({
    required this.skill,
    required this.value,
  });

  SpecializedSkill skill;
  int value;

  factory SpecializedSkillInstance.fromJson(Map<String, dynamic> json) =>
      _$SpecializedSkillInstanceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SpecializedSkillInstanceToJson(this);
}