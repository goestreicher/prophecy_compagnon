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
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_modifier_configuration.dart';
import 'package:prophecy_compagnon_shared/classes/entity/effect.dart';
import 'package:uuid/uuid.dart';

part 'character_advantage.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterAdvantage {
  CharacterAdvantage({
    String? uuid,
    required this.advantage,
    required this.cost,
    required this.details,
    List<String>? effectIds,
  })
    : uuid = uuid ?? Uuid().v4().toString(),
      effectIds = effectIds ?? <String>[];

  final String uuid;
  final Advantage advantage;
  final int cost;
  final String details;
  final List<String> effectIds;

  List<DiceThrowModifier> buildThrowModifiers() {
    var ret = <DiceThrowModifier>[];
    var advantageSuffix = '${advantage.name}.$uuid';

    if(advantage.throwModifierBuilder != null) {
      ret.addAll(
        advantage.throwModifierBuilder!(
          DiceThrowModifierBuilderArgs(
            cost: cost,
            details: details,
            suffix: advantageSuffix,
          )
        )
      );
    }
    else {
      for(var cfg in advantage.throwModifierConfigurations) {
        ret.add(
          AdvantageDiceThrowModifier(
            type: cfg.type,
            label: '${advantage.title}${details.isEmpty ? "" : " - $details"} (Avantage)',
            value: cfg.value!,
            advantageSuffix: advantageSuffix,
          )
        );
      }
    }

    return ret;
  }

  List<EntityEffect> buildEffects() {
    var ret = <EntityEffect>[];

    for(var cfg in advantage.effectConfigurations) {
      var effect = cfg.create();
      effectIds.add(effect.id);
      ret.add(effect);
    }

    var builderArgs = EntityEffectBuilderArgs(cost: cost, details: details);
    for(var effect in (advantage.effectBuilder?.call(builderArgs) ?? <EntityEffect>[])) {
      effectIds.add(effect.id);
      ret.add(effect);
    }

    return ret;
  }

  factory CharacterAdvantage.fromJson(Map<String, dynamic> json) =>
      _$CharacterAdvantageFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CharacterAdvantageToJson(this);
}

class CharacterAdvantages with IterableMixin<CharacterAdvantage>, ChangeNotifier {
  CharacterAdvantages(
    List<CharacterAdvantage>? a,
    {
      this.onAdvantageAdded,
      this.onAdvantageRemoved,
    }
  )
    : _all = a ?? <CharacterAdvantage>[];

  void Function(CharacterAdvantage)? onAdvantageAdded;
  void Function(CharacterAdvantage)? onAdvantageRemoved;

  @override
  Iterator<CharacterAdvantage> get iterator => _all.iterator;

  bool has(Advantage advantage) =>
      _all.any((CharacterAdvantage a) => a.advantage == advantage);

  void add(CharacterAdvantage a) {
    _all.add(a);
    onAdvantageAdded?.call(a);
    notifyListeners();
  }

  void remove(CharacterAdvantage a) {
    if(_all.contains(a)) {
      _all.remove(a);
      onAdvantageRemoved?.call(a);
      notifyListeners();
    }
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