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
import 'package:prophecy_compagnon_mj/ui/session/board/item_map_widget.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item_map.dart';
import 'package:prophecy_compagnon_shared/ui/generic_image_widget.dart';

class SessionBoardItemWidget<T extends SessionBoardItem> extends StatelessWidget {
  const SessionBoardItemWidget({ super.key, required this.item });

  final T item;

  @override
  Widget build(BuildContext context) {
    Widget finalWidget;

    if(item is SessionBoardItemMap) {
      finalWidget = SessionBoardItemMapWidget(
        map: (item as SessionBoardItemMap),
      );
    }
    else {
      finalWidget = InteractiveViewer(
        minScale: 0.1,
        maxScale: 5.0,
        child: GenericImageWidget(
          image: item.image(),
        )
      );
    }

    return finalWidget;
  }
}