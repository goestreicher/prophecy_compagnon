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

part 'ticker.g.dart';

enum TickerDurationUnit {
  action,
  turn,
  minute,
  hour,
  day,
  ;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TickerDuration {
  TickerDuration({
    required this.count,
    required this.unit,
  });

  int count;
  TickerDurationUnit unit;

  factory TickerDuration.fromJson(Map<String, dynamic> json) =>
      _$TickerDurationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TickerDurationToJson(this);
}