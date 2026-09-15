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

import 'dart:typed_data';

import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/session_context_retriever.dart';

class SessionBoardItemImage extends SessionBoardItem {
  SessionBoardItemImage({
    required super.title,
    super.removable,
    required this.content,
  });

  SessionBoardItemImage.fromUint8List({
    required super.title,
    super.removable,
    required Uint8List data,
  })
    : content = GenericImage.memory(binary: ExportableBinaryData(data: data));

  @override
  Future<GenericImage> thumbnail(double maxDimension) async =>
      content.thumbnail(maxDimension);

  @override
  GenericImage image() =>
      content;

  GenericImage content;

  factory SessionBoardItemImage.fromJson(
      Map<String, dynamic> json,
      SessionContextRetriever context
  ) =>
      SessionBoardItemImage(
        title: json['title'] as String,
        removable: json['removable'] as bool? ?? true,
        content: GenericImage.fromJson(json['content'] as Map<String, dynamic>),
      );

  @override
  Map<String, dynamic> boardItemToJson() =>
      <String, dynamic>{
        'title': title,
        'removable': removable,
        'content': content.toJson(),
      };
}