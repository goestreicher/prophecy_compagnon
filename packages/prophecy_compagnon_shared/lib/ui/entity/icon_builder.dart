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
import 'dart:ui';

import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

Future<GenericImage?> buildEntityIcon(EntityBase entity) async {
  GenericImage? ret;

  var pBuilder = ParagraphBuilder(
    ParagraphStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    )
  );
  pBuilder.addText(entity.name[0]);
  Paragraph paragraph = pBuilder.build();
  paragraph.layout(ParagraphConstraints(width: 48));

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawParagraph(paragraph, Offset((50-paragraph.height)/2, (50-paragraph.width)/2));

  final picture = recorder.endRecording();
  final res = await picture.toImage(50, 50);
  ByteData? data = await res.toByteData(format: ImageByteFormat.png);
  if(data != null) {
    ret = GenericImage.memory(binary: ExportableBinaryData(data: Uint8List.view(data.buffer)));
  }

  return ret;
}