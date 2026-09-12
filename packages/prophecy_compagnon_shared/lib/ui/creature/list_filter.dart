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

import 'package:prophecy_compagnon_shared/classes/creature.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';

class CreatureListFilter {
  CreatureListFilter({
    this.sourceType,
    this.source,
    this.category,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  CreatureCategory? category;
  String? search;

  bool match(CreatureSummary c) =>
      (sourceType == null || c.source.type == sourceType)
      && (source == null || c.source == source)
      && (category == null || c.category == category)
      && (search == null || c.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, category, search);

  @override
  bool operator ==(Object other) =>
      other is CreatureListFilter
      && other.sourceType == sourceType
      && other.source == source
      && other.category == category
      && other.search == search;
}