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

import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class OffsetJsonConverter extends JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetJsonConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) => offsetFromJson(json);

  @override
  Map<String, dynamic> toJson(Offset object) => offsetToJson(object);
}

Offset offsetFromJson(Map<String, dynamic> m) {
  return Offset(
    m["dx"]! as double,
    m["dy"]! as double
  );
}

Map<String, dynamic> offsetToJson(Offset o) {
  return {
    "dx": o.dx,
    "dy": o.dy,
  };
}