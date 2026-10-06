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
import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';

part 'luck.g.dart';

@JsonSerializable()
class DiceThrowEntityBaseLuck extends DiceThrowEntityBase {
  const DiceThrowEntityBaseLuck();

  @override
  String get label => 'Chance';

  @override
  String baseLabel(EntityBase entity) => '';

  @override
  int baseValue(EntityBase entity) => 0;

  @override
  String componentLabel(EntityBase entity) => label;

  @override
  int componentValue(EntityBase entity) => entity is HumanCharacter
      ? entity.luck
      : 0;

  @override
  Map<String, dynamic> diceThrowEntityBaseToJson() =>
      _$DiceThrowEntityBaseLuckToJson(this);

  factory DiceThrowEntityBaseLuck.fromJson(Map<String, dynamic> json) =>
      _$DiceThrowEntityBaseLuckFromJson(json);
}