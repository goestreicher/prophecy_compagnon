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

import 'package:json_annotation/json_annotation.dart';

part 'attack_context.g.dart';

@JsonSerializable()
class CombatActionAttackContext {
  CombatActionAttackContext({
    required this.cumulativeAttackMalus,
    required this.targetId,
    this.cumulativeDefenseMalus,
  });

  int cumulativeAttackMalus;
  String targetId;
  int? cumulativeDefenseMalus;

  factory CombatActionAttackContext.fromJson(Map<String, dynamic> json) =>
      _$CombatActionAttackContextFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CombatActionAttackContextToJson(this);
}