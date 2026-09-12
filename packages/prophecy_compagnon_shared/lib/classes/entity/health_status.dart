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

part 'health_status.g.dart';

enum EntityHealthStatusFlag {
  none(value: 0, label: 'OK'),
  injured(value: 1 << 1, label: 'Blessé'),
  dead(value: 1 << 2, label: 'Mort'),
  stunned(value: 1 << 3, label: 'Sonné'),
  unconscious(value: 1 << 4, label: 'Inconscient'),
  ;

  final int value;
  final String label;

  const EntityHealthStatusFlag({ required this.value, required this.label });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'fromBitfield')
class EntityHealthStatusValue {
  EntityHealthStatusValue.empty() : bitfield = 0;
  EntityHealthStatusValue(EntityHealthStatusFlag flag) : bitfield = flag.value;
  EntityHealthStatusValue.fromBitfield(this.bitfield);

  int bitfield;

  EntityHealthStatusValue operator &(EntityHealthStatusValue other) =>
      EntityHealthStatusValue.fromBitfield(other.bitfield & bitfield);

  EntityHealthStatusValue operator |(EntityHealthStatusValue other) =>
      EntityHealthStatusValue.fromBitfield(other.bitfield | bitfield);

  EntityHealthStatusValue operator ~() =>
      EntityHealthStatusValue.fromBitfield(~bitfield);

  @override
  bool operator ==(Object other) =>
      other is EntityHealthStatusValue && other.bitfield == bitfield;

  @override
  int get hashCode => bitfield;

  factory EntityHealthStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityHealthStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityHealthStatusValueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityHealthStatus with ChangeNotifier {
  EntityHealthStatus({ required EntityHealthStatusValue value }) : _value = value;
  EntityHealthStatus.empty() : _value = EntityHealthStatusValue(EntityHealthStatusFlag.none);

  @JsonKey(defaultValue: EntityHealthStatusValue.empty)
  EntityHealthStatusValue get value => _value;
  set value(EntityHealthStatusValue v) {
    _value = v;
    notifyListeners();
  }

  EntityHealthStatusValue _value;

  bool has(EntityHealthStatusFlag status) =>
      (value & EntityHealthStatusValue(status)).bitfield != EntityHealthStatusFlag.none.value;

  void add(EntityHealthStatusFlag status) =>
      value = _value | EntityHealthStatusValue(status);

  void clear(EntityHealthStatusFlag status) =>
      value = _value & ~EntityHealthStatusValue(status);

  factory EntityHealthStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityHealthStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityHealthStatusToJson(this);
}