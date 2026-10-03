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

part 'tendencies.g.dart';

enum Tendency {
  dragon(title: "Dragon"),
  human(title: "Homme"),
  fatality(title: "Fatalité"),
  ;

  final String title;

  const Tendency({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required this.value, required this.circles });

  int value;
  int circles;

  void updateValue(int delta) {
    if(delta == 0) return;

    var target = value + delta;

    if(target < 0) {
      target = 0;
    }
    else if(target > 5) {
      target = 5;
    }

    value = target;
  }

  void updateCircles(int delta) {
    if(delta == 0) return;

    var target = circles + delta;
    var valueDelta = 0;

    if(target < 0) {
      if(value == 0) {
        target = 0;
      }
      else {
        valueDelta = -1 - (target ~/ 10);
        target = (-1 - (target % 10)).abs();
      }
    }
    else if(target > 10) {
      if(value == 5) {
        target = 10;
      }
      else {
        valueDelta = target ~/ 10;
        target = 1 - (target % 10);
      }
    }

    if(valueDelta != 0) {
      updateValue(valueDelta);
    }

    if(target != 0) {
      circles = target;
    }
  }

  factory TendencyAttribute.fromJson(Map<String, dynamic> json) =>
      _$TendencyAttributeFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TendencyAttributeToJson(this);
}

class CharacterTendencyUpdate {
  const CharacterTendencyUpdate({
    required this.tendency,
    required this.circlesDelta,
    this.valueDelta = 0,
  });

  final Tendency tendency;
  final int circlesDelta;
  final int valueDelta;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterTendencies {
  CharacterTendencies.empty()
      : dragon = TendencyAttribute(value: 0, circles: 0),
        human = TendencyAttribute(value: 0, circles: 0),
        fatality = TendencyAttribute(value: 0, circles: 0);

  CharacterTendencies({
    required this.dragon,
    required this.human,
    required this.fatality,
  });

  TendencyAttribute dragon;
  TendencyAttribute human;
  TendencyAttribute fatality;

  TendencyAttribute operator [](Tendency tendency) {
    switch(tendency) {
      case Tendency.dragon:
        return dragon;
      case Tendency.human:
        return human;
      case Tendency.fatality:
        return fatality;
    }
  }

  void update(CharacterTendencyUpdate delta) {
    if(delta.valueDelta != 0) {
      this[delta.tendency].updateValue(delta.valueDelta);
    }

    if(delta.circlesDelta != 0) {
      this[delta.tendency].updateCircles(delta.circlesDelta);
    }
  }

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) =>
      _$CharacterTendenciesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CharacterTendenciesToJson(this);
}