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

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/entity/spirit_powers.dart';

part 'fervor.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityFervor {
  EntityFervor({
    this.value = 0,
    List<SpiritPower>? powers,
  })
    : powers = EntitySpiritPowers(powers: powers);

  int value;
  EntitySpiritPowers powers;

  factory EntityFervor.fromJson(Map<String, dynamic> json) =>
      _$EntityFervorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityFervorToJson(this);
}

class EntitySpiritPowers with IterableMixin<SpiritPower>, ChangeNotifier {
  EntitySpiritPowers({ List<SpiritPower>? powers })
    : _all = powers ?? <SpiritPower>[];

  @override
  Iterator<SpiritPower> get iterator => _all.iterator;

  void add(SpiritPower s) {
    _all.add(s);
    notifyListeners();
  }

  void remove(SpiritPower s) {
    _all.remove(s);
    notifyListeners();
  }

  final List<SpiritPower> _all;
}