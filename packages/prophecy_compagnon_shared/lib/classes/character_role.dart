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
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';

part 'character_role.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterRole {
  CharacterRole({
    this.name,
    this.link,
    required this.title,
  })
  {
    if(name == null && link == null) {
      throw ArgumentError('Either name or link must be provided to create a faction member');
    }
  }

  String? name;
  ResourceLink? link;
  String title;

  factory CharacterRole.fromJson(Map<String, dynamic> j) =>
      _$CharacterRoleFromJson(j);
  Map<String, dynamic> toJson() =>
      _$CharacterRoleToJson(this);
}