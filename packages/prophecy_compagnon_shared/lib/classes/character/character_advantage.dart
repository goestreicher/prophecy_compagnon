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

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/character/advantages.dart';

part 'character_advantage.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterAdvantage {
  CharacterAdvantage({
    required this.advantage,
    required this.cost,
    required this.details,
  });

  final Advantage advantage;
  final int cost;
  final String details;

  factory CharacterAdvantage.fromJson(Map<String, dynamic> json) =>
      _$CharacterAdvantageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CharacterAdvantageToJson(this);
}

class CharacterAdvantages with IterableMixin<CharacterAdvantage>, ChangeNotifier {
  CharacterAdvantages(
    List<CharacterAdvantage>? a
  )
    : _all = a ?? <CharacterAdvantage>[];

  @override
  Iterator<CharacterAdvantage> get iterator => _all.iterator;

  void add(CharacterAdvantage a) {
    _all.add(a);
    notifyListeners();
  }

  void remove(CharacterAdvantage a) {
    if(_all.remove(a)) notifyListeners();
  }

  static CharacterAdvantages fromJson(List<dynamic>? json) =>
      CharacterAdvantages(
        json
          ?.map<CharacterAdvantage>(
            (a) => CharacterAdvantage.fromJson(a as Map<String, dynamic>)
          )
          .toList()
      );

  static List<Map<String, dynamic>> toJson(CharacterAdvantages all) =>
      all
        .map((CharacterAdvantage a) => a.toJson())
        .toList();

  final List<CharacterAdvantage> _all;
}