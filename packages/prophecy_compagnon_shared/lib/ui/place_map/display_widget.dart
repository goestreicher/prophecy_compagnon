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

import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/place_map.dart';

class PlaceMapDisplayWidget extends StatelessWidget {
  const PlaceMapDisplayWidget({ super.key, required this.map });

  final PlaceMap map;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: map.load(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError || map.image == null) {
          return ErrorWidget('Échec de chargement de la carte');
        }

        return InteractiveViewer(
          child: Image.memory(map.image!)
        );
      }
    );
  }
}