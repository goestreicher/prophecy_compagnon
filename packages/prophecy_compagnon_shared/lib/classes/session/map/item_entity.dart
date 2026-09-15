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

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';
import 'package:prophecy_compagnon_shared/ui/entity/icon_builder.dart';

class SessionMapEntityItem extends SessionMapItem {
  SessionMapEntityItem({
    super.x,
    super.y,
    required this.entity,
  });

  final EntityBase entity;

  @override
  String get id => entity.id;

  @override
  String? get label => entity.name;

  @override
  Size get size => Size(entity.size, entity.size);

  @override
  Future<GenericImage?> get image async {
    if(_icon == null) {
      if(entity.icon != null) {
        _icon = GenericImage.memory(binary: entity.icon!);
      }
      else {
        _icon = await buildEntityIcon(entity);
      }
    }
    return _icon;
  }

  @override
  bool get movable => true;

  @override
  double get movementDistance => entity.baseMovementDistance;

  factory SessionMapEntityItem.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context,
  ) {
    return SessionMapEntityItem(
      x: json['x'] as double?,
      y: json['y'] as double?,
      entity: context.entity((json['entityId'] as String))!,
    );
  }

  @override
  Map<String, dynamic> mapItemToJson() {
    return {
      'x': x,
      'y': y,
      'entityId': entity.id,
    };
  }

  GenericImage? _icon;
}