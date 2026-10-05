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
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/human_character.dart';

part 'threshold.g.dart';

enum DiceThrowThresholdComparison {
  lowerThan,
  lowerThanOrEqual,
}

abstract class DiceThrowEntityBaseThreshold extends DiceThrowEntityBase {
  const DiceThrowEntityBaseThreshold({
    required this.comparison,
  });

  final DiceThrowThresholdComparison comparison;

  bool throwSucceeds(EntityBase entity, int dieThrow) {
    switch(comparison) {
      case DiceThrowThresholdComparison.lowerThan:
        return dieThrow < value(entity);
      case DiceThrowThresholdComparison.lowerThanOrEqual:
        return dieThrow <= value(entity);
    }
  }

  @override
  String componentLabel(EntityBase entity) => '';

  @override
  int componentValue(EntityBase entity) => 0;
}

@JsonSerializable()
class DiceThrowEntityBaseThresholdAbility extends DiceThrowEntityBaseThreshold {
  const DiceThrowEntityBaseThresholdAbility({
    required super.comparison,
    required this.ability,
  });

  final Ability ability;

  @override
  String get label => ability.title;

  @override
  String baseLabel(EntityBase entity) => label;

  @override
  int baseValue(EntityBase entity) => entity.abilities[ability];

  @override
  Map<String, dynamic> diceThrowEntityBaseToJson() =>
      _$DiceThrowEntityBaseThresholdAbilityToJson(this);

  factory DiceThrowEntityBaseThresholdAbility.fromJson(Map<String, dynamic> json) =>
      _$DiceThrowEntityBaseThresholdAbilityFromJson(json);
}

@JsonSerializable()
class DiceThrowEntityBaseThresholdLuck extends DiceThrowEntityBaseThreshold {
  const DiceThrowEntityBaseThresholdLuck({
    required super.comparison,
  });

  @override
  String get label => 'Chance';

  @override
  String baseLabel(EntityBase entity) => label;

  @override
  int baseValue(EntityBase entity) => entity is HumanCharacter ? entity.luck : 0;

  @override
  Map<String, dynamic> diceThrowEntityBaseToJson() =>
      _$DiceThrowEntityBaseThresholdLuckToJson(this);

  factory DiceThrowEntityBaseThresholdLuck.fromJson(Map<String, dynamic> json) =>
      _$DiceThrowEntityBaseThresholdLuckFromJson(json);
}