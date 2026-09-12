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

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combat_status.g.dart';

enum EntityCombatStatusFlag {
  none(value: 0, label: 'OK'),
  onGround(value: 1 << 1, label: 'Au sol'),
  grappled(value: 1 << 2, label: 'Saisi(e)'),
  ;

  final int value;
  final String label;

  const EntityCombatStatusFlag({ required this.value, required this.label });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'fromBitfield')
class EntityCombatStatusValue {
  EntityCombatStatusValue.empty() : bitfield = 0;
  EntityCombatStatusValue(EntityCombatStatusFlag flag) : bitfield = flag.value;
  EntityCombatStatusValue.fromBitfield(this.bitfield);

  int bitfield;

  EntityCombatStatusValue operator &(EntityCombatStatusValue other) =>
      EntityCombatStatusValue.fromBitfield(other.bitfield & bitfield);

  EntityCombatStatusValue operator |(EntityCombatStatusValue other) =>
      EntityCombatStatusValue.fromBitfield(other.bitfield | bitfield);

  EntityCombatStatusValue operator ~() =>
      EntityCombatStatusValue.fromBitfield(~bitfield);

  @override
  bool operator ==(Object other) =>
      other is EntityCombatStatusValue && other.bitfield == bitfield;

  @override
  int get hashCode => bitfield;

  factory EntityCombatStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusValueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityCombatStatus with ChangeNotifier {
  EntityCombatStatus({ required EntityCombatStatusValue value }) : _value = value;
  EntityCombatStatus.empty() : _value = EntityCombatStatusValue(EntityCombatStatusFlag.none);

  @JsonKey(defaultValue: EntityCombatStatusValue.empty)
  EntityCombatStatusValue get value => _value;
  set value(EntityCombatStatusValue v) {
    _value = v;
    notifyListeners();
  }

  EntityCombatStatusValue _value;

  bool has(EntityCombatStatusFlag status) =>
      (value & EntityCombatStatusValue(status)).bitfield != EntityCombatStatusFlag.none.value;

  void add(EntityCombatStatusFlag status) =>
      value = _value | EntityCombatStatusValue(status);

  void clear(EntityCombatStatusFlag status) =>
      value = _value & ~EntityCombatStatusValue(status);

  factory EntityCombatStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusToJson(this);
}