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

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/storage/default_assets_store.dart';

part 'generic_image.g.dart';

enum GenericImageSourceType {
  asset,
  local,
  memory,
  url,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GenericImage {
  GenericImage({
    required this.sourceType,
    required this.source,
  });

  GenericImage.memory({
    this.source = 'memory',
    required this.binary,
  })
    : sourceType = GenericImageSourceType.memory;

  GenericImageSourceType sourceType;
  String source;

  @JsonKey(includeFromJson: false, includeToJson: false)
    ExportableBinaryData? binary;

  @JsonKey(includeFromJson: false, includeToJson: false)
    int? width;

  @JsonKey(includeFromJson: false, includeToJson: false)
    int? height;

  Future<void> load() async {
    try {
      if(binary == null) {
        switch (sourceType) {
          case GenericImageSourceType.memory:
          case GenericImageSourceType.url:
            break;
          case GenericImageSourceType.local:
            binary = await BinaryDataStore().get(source);
          case GenericImageSourceType.asset:
            var bytes = await loadAssetByteData(source);
            binary = ExportableBinaryData(
                data: Uint8List.sublistView(bytes)
            );
        }
      }

      if(binary == null) return;

      var codec = await ui.instantiateImageCodec(binary!.data);
      var frame = await codec.getNextFrame();
      width = frame.image.width;
      height = frame.image.height;
      frame.image.dispose();
    }
    catch(e) {
      binary = null;
      width = null;
      height = null;
      rethrow;
    }
  }

  Future<GenericImage> thumbnail(double maxDimension) async {
    await load();
    // TODO
    return this;
  }

  factory GenericImage.fromJson(Map<String, dynamic> json) {
    var ret = _$GenericImageFromJson(json);
    if(ret.sourceType == GenericImageSourceType.memory && json['binary'] != null) {
      ret.binary = ExportableBinaryData.fromJson(json['binary']!);
    }
    return ret;
  }

  Map<String, dynamic> toJson() {
    var ret = _$GenericImageToJson(this);
    if(sourceType == GenericImageSourceType.memory && binary != null) {
      ret['binary'] = binary!.toJson();
    }
    return ret;
  }
}