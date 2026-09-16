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

import 'package:prophecy_compagnon_shared/classes/dice/throw_matcher.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_type.dart';
import 'package:prophecy_compagnon_shared/classes/equipment/equipment.dart';

abstract class DiceThrowModifier {
  DiceThrowModifier({
    required this.type,
    required this.label,
    required this.value,
    this.matcher,
  });

  final DiceThrowModifierType type;
  final String label;
  final int value;
  final DiceThrowMatcher? matcher;

  String get suffix;

  String get id => '${type.name}.$suffix';
}

class OneOffDiceThrowModifier extends DiceThrowModifier {
  OneOffDiceThrowModifier({
    required super.type,
    required super.label,
    required super.value,
    required this.name,
  });

  String name;

  @override
  String get suffix => name;
}

class EquipmentDiceThrowModifier extends DiceThrowModifier {
  EquipmentDiceThrowModifier({
    required super.type,
    required super.label,
    required super.value,
    super.matcher,
    required this.equipment,
  });

  final Equipment equipment;

  @override
  String get suffix => '${equipment.runtimeType.toString()}.${equipment.uuid()}';
}