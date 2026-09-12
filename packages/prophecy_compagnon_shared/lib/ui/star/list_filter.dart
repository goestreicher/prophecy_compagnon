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

import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';

class StarListFilter {
  StarListFilter({
    this.sourceType,
    this.source,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  String? search;

  bool match(Star star) =>
      (sourceType == null || star.source.type == sourceType)
      && (source == null || star.source == source)
      && (search == null || star.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, search);

  @override
  bool operator ==(Object other) =>
      other is StarListFilter
          && other.sourceType == sourceType
          && other.source == source
          && other.search == search;
}