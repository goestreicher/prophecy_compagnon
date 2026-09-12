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
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';
import 'package:prophecy_compagnon_shared/ui/star/edit_widget.dart';

class StarEditPage extends StatelessWidget {
  const StarEditPage({ super.key, required this.id });

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Star.get(id),
        builder: (BuildContext context, AsyncSnapshot<Star?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Étoile non trouvée'),
            );
          }

          var star = snapshot.data!;

          return StarEditWidget(
            star: star,
            onEditDone: (bool result) async {
              if(result) {
                await Star.saveLocalModel(star);
                if(!context.mounted) return;
                context.go('/stars/${star.id}');
              }
              else {
                await Star.reloadFromStore(id);
                if(!context.mounted) return;
                context.go('/stars/${star.id}');
              }
            }
          );
        }
    );
  }
}