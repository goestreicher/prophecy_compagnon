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

import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/offset_json_convert.dart';

part 'movement_path.g.dart';

@OffsetJsonConverter()
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovementPathSegment {
  MovementPathSegment({
    required this.start,
    required this.end,
  });

  MovementPathSegment.from(MovementPathSegment other)
    : start = Offset(other.start.dx, other.start.dy),
      end = Offset(other.end.dx, other.end.dy);

  final Offset start;
  Offset end;

  double get length => sqrt(
      pow(start.dx - end.dx, 2) + pow(start.dy - end.dy, 2)
  );

  factory MovementPathSegment.fromJson(Map<String, dynamic> json) =>
      _$MovementPathSegmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MovementPathSegmentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovementPath {
  MovementPath({ List<MovementPathSegment>? segments })
      : segments = segments ?? <MovementPathSegment>[];

  MovementPath.from(MovementPath other)
    : segments = <MovementPathSegment>[]
  {
    for(var s in other.segments) {
      segments.add(MovementPathSegment.from(s));
    }
  }

  final List<MovementPathSegment> segments;

  bool get isEmpty => segments.isEmpty;
  bool get isNotEmpty => segments.isNotEmpty;
  MovementPathSegment? get first => segments.isEmpty ? null : segments.first;
  MovementPathSegment? get last => segments.isEmpty ? null : segments.last;

  double get length => segments.isEmpty
      ? 0.0
      : segments
      .map((MovementPathSegment s) => s.length)
      .reduce((double v, double e) => v + e);

  factory MovementPath.fromJson(Map<String, dynamic> json) =>
      _$MovementPathFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MovementPathToJson(this);
}