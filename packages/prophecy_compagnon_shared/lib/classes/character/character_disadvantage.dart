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
import 'package:prophecy_compagnon_shared/classes/character/disadvantages.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_configuration.dart';
import 'package:uuid/uuid.dart';

part 'character_disadvantage.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterDisadvantage {
  CharacterDisadvantage({
    String? uuid,
    required this.disadvantage,
    required this.cost,
    required this.details,
  })
    : uuid = uuid ?? Uuid().v4().toString();

  final String uuid;
  final Disadvantage disadvantage;
  final int cost;
  final String details;

  List<DiceThrowModifier> buildThrowModifiers() {
    var ret = <DiceThrowModifier>[];
    var disadvantageSuffix = '${disadvantage.name}.$uuid';

    if(disadvantage.throwModifierBuilder != null) {
      ret.addAll(
        disadvantage.throwModifierBuilder!(
          DiceThrowModifierBuilderArgs(
            cost: cost,
            details: details,
            suffix: disadvantageSuffix,
          )
        )
      );
    }
    else {
      for(var cfg in disadvantage.throwModifierConfigurations) {
        ret.add(
          DisadvantageDiceThrowModifier(
            type: cfg.type,
            label: '${disadvantage.title}${details.isEmpty ? "" : " - $details"} (Désavantage)',
            value: cfg.value!,
            disadvantageSuffix: disadvantageSuffix,
          )
        );
      }
    }

    return ret;
  }

  factory CharacterDisadvantage.fromJson(Map<String, dynamic> json) =>
      _$CharacterDisadvantageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CharacterDisadvantageToJson(this);
}

class CharacterDisadvantages with IterableMixin<CharacterDisadvantage>, ChangeNotifier {
  CharacterDisadvantages(
    List<CharacterDisadvantage>? d
  )
    : _all = d ?? <CharacterDisadvantage>[];

  @override
  Iterator<CharacterDisadvantage> get iterator => _all.iterator;

  bool has(Disadvantage disadvantage) =>
      _all.any((CharacterDisadvantage d) => d.disadvantage == disadvantage);

  void add(CharacterDisadvantage d) {
    _all.add(d);
    notifyListeners();
  }

  void remove(CharacterDisadvantage d) {
    if(_all.remove(d)) notifyListeners();
  }

  static CharacterDisadvantages fromJson(List<dynamic>? json) =>
      CharacterDisadvantages(
        json
          ?.map<CharacterDisadvantage>(
            (dynamic d) =>
              CharacterDisadvantage.fromJson(d as Map<String, dynamic>)
            )
          .toList()
      );

  static List<Map<String, dynamic>> toJson(CharacterDisadvantages all) =>
      all
        .map((CharacterDisadvantage d) => d.toJson())
        .toList();

  final List<CharacterDisadvantage> _all;
}