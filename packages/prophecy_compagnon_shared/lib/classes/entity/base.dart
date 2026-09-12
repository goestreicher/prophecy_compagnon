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

import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/entity/abilities.dart';

part 'base.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AttributeBasedCalculator {
  AttributeBasedCalculator({
    this.static,
    this.ability,
    this.multiply = 1,
    this.add = 0,
    this.dice = 0,
  }) {
    if(static == null && ability == null) {
      throw ArgumentError('Either "static" or "ability" must be set');
    }
  }

  final double? static;
  final Ability? ability;
  final int multiply;
  final int add;
  final int dice;

  double calculate(int abilityValue, { List<int>? throws }) {
    var base = 0.0;
    var rnd = 0;

    if(static != null) {
      base = static!;
    }
    else if(ability != null) {
      base = ((abilityValue * multiply) + add).toDouble();
    }

    if(throws == null) {
      for (var i = 0; i < dice; ++i) {
        rnd += (Random().nextInt(10) + 1);
      }
    }
    else {
      rnd += throws.reduce((value, element) => value + element);
    }

    return (base + rnd).toDouble();
  }

  @override
  String toString() {
    String ret = 'N/A';

    if(static != null && static! > 0) {
      ret = static.toString();
    }
    else if(ability != null) {
      var ab = ability!.short;
      var buffer = StringBuffer(multiply > 1
          ? '(${ab}x$multiply)'
          : ab);
      if(add > 0) {
        buffer.write(' + $add');
      }
      if(dice > 0) {
        buffer.write(' + ${dice}D10');
      }
      ret = buffer.toString();
    }

    return ret;
  }

  factory AttributeBasedCalculator.fromJson(Map<String, dynamic> json) =>
      _$AttributeBasedCalculatorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeBasedCalculatorToJson(this);
}
