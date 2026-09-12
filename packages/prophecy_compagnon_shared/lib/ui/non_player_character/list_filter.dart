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

import 'package:prophecy_compagnon_shared/classes/non_player_character.dart';
import 'package:prophecy_compagnon_shared/classes/npc_category.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';

class NPCListFilter {
  NPCListFilter({
    this.sourceType,
    this.source,
    this.category,
    this.subCategory,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  NPCCategory? category;
  NPCSubCategory? subCategory;
  String? search;

  bool match(NonPlayerCharacterSummary npc) =>
      (sourceType == null || npc.source.type == sourceType)
      && (source == null || npc.source == source)
      && (category == null || npc.category == category)
      && (subCategory == null || npc.subCategory == subCategory)
      && (search == null || npc.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, category, subCategory, search);

  @override
  bool operator ==(Object other) =>
      other is NPCListFilter
      && other.sourceType == sourceType
      && other.source == source
      && other.category == category
      && other.subCategory == subCategory
      && other.search == search;
}