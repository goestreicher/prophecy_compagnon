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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/map/item_entity.dart';
import 'package:prophecy_compagnon_shared/ui/entity/pill_widget.dart';

class SessionMapItemWidget extends StatelessWidget {
  const SessionMapItemWidget({
    super.key,
    required this.item,
    required this.ppm,
  });

  final SessionMapItem item;
  final double ppm;

  @override
  Widget build(BuildContext context) {
    var w = item.size.width * ppm;
    var h = item.size.height * ppm;

    if(item is SessionMapEntityItem) {
      return FutureBuilder(
          future: item.image,
          builder: (BuildContext context, AsyncSnapshot<GenericImage?> snapshot) {
            GenericImage? image;

            if(!snapshot.hasError && snapshot.data != null) {
              image = snapshot.data!;
            }

            return EntityPillWidget(
              entity: (item as SessionMapEntityItem).entity,
              width: w,
              height: h,
              image: image,
            );
          }
      );
    }
    else {
      throw(UnimplementedError());
    }
  }
}