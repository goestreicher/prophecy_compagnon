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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/ui/entity/icon_builder.dart';
import 'package:prophecy_compagnon_shared/ui/generic_image_widget.dart';

class EntityPillWidget extends StatelessWidget {
  const EntityPillWidget({
    super.key,
    required this.entity,
    required this.width,
    required this.height,
    this.image,
  });

  final EntityBase entity;
  final double width;
  final double height;
  final GenericImage? image;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget imageWidget;
    var borderWidth = 4.0;

    if(image != null) {
      imageWidget = GenericImageWidget(
        image: image!,
      );
    }
    else if(entity.icon != null) {
      imageWidget = GenericImageWidget(
        image: GenericImage.memory(binary: entity.icon!),
      );
    }
    else {
      imageWidget = FutureBuilder(
        future: buildEntityIcon(entity),
        builder: (BuildContext context, AsyncSnapshot<GenericImage?> snapshot) {
          if(snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                entity.name[0],
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return GenericImageWidget(
              image: snapshot.data!
          );
        },
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: borderWidth),
        borderRadius: BorderRadius.circular(max(width, height) / 2),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(max(width, height)/2 - borderWidth/2),
        child: imageWidget,
      ),
    );
  }
}